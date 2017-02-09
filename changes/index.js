var config = require('../lib/config')();
var queue = require('d3-queue').queue;
var pg = require('pg');
require('../validators');
var validate = require('validate.js');
var errors = require('../errors');
var squel = require('squel').useFlavour('postgres');

var changes = {};

module.exports = changes;
var pgURL = config.PostgresURL;

changes.get = function(from, to, users, tags, callback) {
    var parseError = validateParams({'from': from, 'to': to});
    if (parseError) {
        return callback(new errors.ParseError(parseError));
    }

    getQuery(from, to, users, tags, function(err, query) {
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
                callback(null, result.rows);
            });
        });
    });
};

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

function getQuery(from, to, users, tags, callback) {

    var sql = squel.select({'parameterCharacter': '!!'})
        .from('stats')
        .where('change_at > !!', from)
        .where('change_at < !!', to);

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

        getUserIds(usersArray, function(err, userIds) {
            if (err) {
                return callback(err);
            }

            sql.where('uid in !!', userIds);
            callback(null, sql.toParam());
        });
    } else {

        callback(null, sql.toParam());
    }


}

function getUserIds(users, callback) {
    var userSql = squel.select({'parameterCharacter': '!!'})
        .from('users')
        .field('id')
        .where('name in !!', users);

    var userIds = [];
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
            result.rows.forEach(function (r) {
                userIds.push(r.id);
            });
            callback(null, userIds);

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
        } else {
            tagsSql.or('tags_created ? !!', key);
            tagsSql.or('tags_modified ? !!', key);
        }
    });
    return tagsSql;
}