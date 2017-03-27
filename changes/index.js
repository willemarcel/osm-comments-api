var config = require('../lib/config')();
require('../validators');
var validate = require('validate.js');
var errors = require('../errors');
var squel = require('squel').useFlavour('postgres');
var helpers = require('../helpers');
var moment = require('moment');
var union = require('lodash.union');
var changes = {};

module.exports = changes;
var pgURL = config.PostgresURL;
var pgPromise = helpers.pgPromise;
var promisifyQuery = helpers.promisifyQuery;

changes.get = function(from, to, users, tags, bbox) {
    var parseError = validateParams({'from': from, 'to': to});
    var usersData, searchQuery;
    if (parseError) {
        return Promise.reject(new errors.ParseError(parseError));
    }
    
    return getQueryAndUserData(from, to, users, tags, bbox)
        .then(function (obj) {
            // save vars for future use.
            usersData = obj.usersData;
            searchQuery = obj.query;
            return pgPromise(pgURL);
        })
        .then(function (pg) {
            var query = promisifyQuery(pg.client);
            return query(searchQuery)
            .then(function (r) {
                pg.done();
                return r;
            })
            .catch(function(e) {
                pg.done();
                return Promise.reject(e);
            });
        })
        .then(function (res) {
            var userLookup = {};
            if (usersData) {
                usersData.rows.forEach(function (u) {
                    userLookup[u.id] = u.name;
                });
                res.rows.forEach(function (r) {
                    r.username = userLookup[r.uid];
                });
            }
            return res.rows.reduce(reducerFn, {});
        });
};

function reducerFn(memo, row) {
    var hour = moment.utc(row.change_at).startOf('hour').toISOString();
    if (!memo.hasOwnProperty(hour)) {
        memo[hour] = {};
    }
    var username = row.username;
    if (!memo[hour].hasOwnProperty(username)) {
        memo[hour][username] = {};
    }
    var thisUserMemo = memo[hour][username];
    ['nodes', 'ways', 'relations'].forEach(function (thing) {
        if (!thisUserMemo.hasOwnProperty(thing)) {
            thisUserMemo[thing] = {
                'c': 0,
                'm': 0,
                'd': 0
            };
        }
        ['c', 'm', 'd'].forEach(function (type) {
            // if row does not always contain these, add error handling:
            thisUserMemo[thing][type] += row[thing][type];
        });
    });
    ['tags_created', 'tags_modified', 'tags_deleted'].forEach(function (thing) {
        if (!thisUserMemo.hasOwnProperty(thing)) {
            thisUserMemo[thing] = {};
        }
        Object.keys(row[thing]).forEach(function (tag) {
            if (!thisUserMemo[thing].hasOwnProperty(tag)) {
                thisUserMemo[thing][tag] = {};
            }
            Object.keys(row[thing][tag]).forEach(function (value) {
                if (!thisUserMemo[thing][tag].hasOwnProperty(value)) {
                    thisUserMemo[thing][tag][value] = 0;
                }
                thisUserMemo[thing][tag][value] += row[thing][tag][value];
            });

        });
    });

    thisUserMemo.changesets = union(thisUserMemo.changesets, row.changesets);
    return memo;
}

function validateParams(params) {
    var constraints = {
        'from': {
            'presence': true,
            'datetime': true
        },
        'to': {
            'presence': true,
            'datetime': true
        }
    };
    var errs = validate(params, constraints);
    if (errs) {
        var errMsg = Object.keys(errs).map(function(key) {
            return errs[key][0];
        }).join(', ');
        return errMsg;
    }
    return null;
}

// @returns Promise
function getQueryAndUserData(from, to, users, tags, bbox) {

    var sql = squel.select({'parameterCharacter': '!!'})
    .from('stats')
    .where('change_at > !!', from)
    .where('change_at < !!', to);

    if (bbox) {
        var polygonGeojson = JSON.stringify(helpers.getPolygon(bbox).geometry);
        var changesetSql = squel.select({'parameterCharacter': '!!'})
        .field('array_agg(id)')
        .from('changesets')
        .where('created_at > !!', from)
        .where('created_at < !!', to)
        .where('ST_Intersects(changesets.bbox, ST_SetSRID(ST_GeomFromGeoJSON(!!), 4326))', polygonGeojson);
        sql = sql.where('changesets <@ !!', changesetSql);
    }

    if (tags) {
        var tagsArray = tags.split(',').map(function(tag) {
            return tag;
        });
        var tagSql = prepareTagQuery(tagsArray, sql);
        sql = sql.where(tagSql);
    }

    if (users) {
        var usersArray = users.split(',').map(function(user) {
            return user;
        });
        return getUserIds(usersArray)
                .then(function(usersData) {
                    var userIds = [];
                    usersData.rows.forEach(function (r) {
                        userIds.push(r.id);
                    });
                    sql.where('uid in !!', userIds);
                    return {
                        query: sql.toParam(),
                        usersData: usersData
                    };
                });
    }

    sql.field('u.name', 'username')
        .field('stats.id', 'id')
        .field('uid')
        .field('change_at')
        .field('nodes')
        .field('ways')
        .field('relations')
        .field('tags_created')
        .field('tags_modified')
        .field('tags_deleted')
        .field('changesets')
        .join('users', 'u', 'u.id = stats.uid');
    console.log('#sql', sql.toString());
    return Promise.resolve({
        query: sql.toParam()
    });
}

// @returns Promise
function getUserIds(users) {
    var userSql = squel.select({'parameterCharacter': '!!'})
        .from('users')
        .field('id')
        .field('name')
        .where('name in !!', users);

    return pgPromise(pgURL)
        .then(function(pg) {
            var query = promisifyQuery(pg.client);
            return query(userSql.toParam())
            .then(function (r) {
                pg.done();
                return r;
            })
            .catch(function (e) {
                pg.done();
                return Promise.reject(e);
            });
        })
        .then(function (result) {
            if (result.rows.length === 0) {
                return Promise.reject(new errors.NotFoundError('No such users'));
            }
            return result;
        });
}

function prepareTagQuery(tags) {
    // SELECT * FROM json_test WHERE data ? 'a'; - check if 'a' exists as a key.
    // SELECT * FROM json_test WHERE data ?| array['a', 'b'];
    // select tags_created from stats where tags_created -> 'shop' ? 'tattoo';

    var tagsSql = squel.expr();
    tagsSql.options.parameterCharacter = '!!';

    tags.forEach(function (tag) {
        var key = tag.split('=')[0];
        var value = tag.split('=')[1];
        if (value !== '*') {
            tagsSql.or('tags_created -> !! ? !!', key, value);
            tagsSql.or('tags_modified -> !! ? !!', key, value);
            tagsSql.or('tags_deleted -> !! ? !!', key, value);
        } else {
            tagsSql.or('tags_created ? !!', key);
            tagsSql.or('tags_modified ? !!', key);
            tagsSql.or('tags_deleted ? !!', key);
        }
    });
    return tagsSql;
}
