var config = require('../lib/config')();
var pg = require('pg');
require('../validators');
var validate = require('validate.js');
var errors = require('../errors');
var squel = require('squel').useFlavour('postgres');
var helpers = require('../helpers');
var moment = require('moment');

var changes = {};

module.exports = changes;
var pgURL = config.PostgresURL;

changes.get = function(from, to, users, tags, bbox, callback) {
    var parseError = validateParams({'from': from, 'to': to});
    if (parseError) {
        return callback(new errors.ParseError(parseError));
    }

    getQuery(from, to, users, tags, bbox, function(err, query, usersData) {
        if (err) {
            callback(err, null);
            return;
        }
        pg.connect(pgURL, function(err, client, done) {
            if (err) {
                callback(err, null);
                return;
            }
            console.log(query);
            client.query(query, function(err, result) {
                done();
                if (err) {
                    return callback(err, null);
                }
                if (result.rows.length === 0) {
                    return callback(new errors.NotFoundError('No records found'));
                }

                var userLookup = {};

                if (usersData) {
                    usersData.rows.forEach(function (u) {
                        userLookup[u.id] = u.name;
                    });

                    result.rows.forEach(function (r) {
                        r.username = userLookup[r.uid];
                    });
                }

                var userBuckets = {};
                var hourlyBuckets = {};

                result.rows.forEach(function (r) {
                    if (userBuckets.hasOwnProperty(r.username)) {
                        userBuckets[r.username].push(r);
                    } else {
                        userBuckets[r.username] = [r];
                    }
                });

                Object.keys(userBuckets).forEach(function(u) {
                    hourlyBuckets = userBuckets[u].reduce(function (hourlyBuckets, d) {
                        var hour = moment.utc(d.change_at).startOf('hour').toISOString();
                        if (hourlyBuckets.hasOwnProperty(hour)) {
                            if (hourlyBuckets[hour].hasOwnProperty(d.username)) {
                                ['nodes', 'ways', 'relations'].forEach(function (thing) {
                                    ['c', 'm', 'd'].forEach(function (type) {
                                        hourlyBuckets[hour][d.username][thing][type] = d[thing][type];
                                    });
                                });
                            } else {
                                hourlyBuckets[hour][d.username] = d;
                            }
                        } else {
                            hourlyBuckets[hour] = {};
                            hourlyBuckets[hour][d.username] = d;
                        }
                        return hourlyBuckets;
                    });
                });

                callback(null, hourlyBuckets);
            });
        });
    });
};

// function aggregate(hour, minute) {
//     var hourKeys = Object.keys(hour);
//     var user = minute.user;
//     hour.forEach(function (h) {
//         if (h.user == minute.user) {

//             ['nodes', 'ways', 'relations'].forEach(function (thing) {
//                 ['c', 'm', 'd'].forEach(function (type) {
//                     h[thing][type] = minute.user[thing][type];
//                 });
//             });

//             ['tags_created', 'tags_modified', 'tags_deleted'].forEach(function (thing) {
//                 Object.keys(minute[thing]).forEach(function (k) {
//                     if (h[thing].hasOwnProperty(k)) {
//                         Object.keys(minute[thing].k).forEach(function (v) {
//                             if (h[thing].k.hasOwnProperty(v)) {
//                                 h[thing].k.v = h[thing].k.v + minute.thing.k.v;
//                             } else {
//                                 h[thing].k[v] = minute.thing.k.v;
//                             }
//                         });
//                     } else {
//                         h[thing][k] = minute[thing][k];
//                     }
//                 });
//             });
//         } else {
//             h[user] = minute;
//         }
//     });
//     console.log(hour);
//     return hour;
// }

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

function getQuery(from, to, users, tags, bbox, callback) {

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

        getUserIds(usersArray, function(err, usersData) {
            if (err) {
                return callback(err);
            }

            var userIds = [];
            usersData.rows.forEach(function (r) {
                userIds.push(r.id);
            });

            sql.where('uid in !!', userIds);
            callback(null, sql.toParam(), usersData);
        });
    } else {
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
        callback(null, sql.toParam());
    }


}

function getUserIds(users, callback) {
    var userSql = squel.select({'parameterCharacter': '!!'})
        .from('users')
        .field('id')
        .field('name')
        .where('name in !!', users);

    pg.connect(pgURL, function(err, client, done) {
        if (err) {
            return callback(err, null);
        }
        client.query(userSql.toParam(), function(err, result) {
            done();
            if (err) {
                return callback(err);
            }

            if (result.rows.length === 0) {
                return callback(new errors.NotFoundError('No such users'));
            }
            callback(null, result);

        });
    });
}

function prepareTagQuery(tags, sql) {
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
