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
    console.log('preparing query for', users);

    var sql = squel.select()
        .from('stats')
        .where('change_at > ?', from)
        .where('change_at < ?', to);

    if (users) {
        var usersArray = users.split(',').map(function(user) {
            return user;
        });

        console.log(usersArray);

        var userSql = squel.select()
            .from('users')
            .field('id')
            .where('name in ?', usersArray);

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
                sql.where('uid in ?', userIds);

                if (tags) {
                    var tagsArray = tags.split(',').map(function(tag) {
                        return tag;
                    });
                    console.log('# tags', tagsArray);

                }
                callback(null, sql.toParam());
            });
        });
    } else {
        callback(null, sql.toParam());
    }
}