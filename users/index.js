var config = require('../lib/config')();
var queue = require('d3-queue').queue;
var pg = require('pg');
var errors = require('../errors');

var users = {};

module.exports = users;

var pgURL = config.PostgresURL;

users.getName = function(name, callback) {
    query(name, 'name', function (err, user) {
        if (err) {
            return callback(err, null);
        }

        callback(null, user);
    });
};

users.getId = function(id, callback) {
    query(id, 'id', function (err, user) {
        if (err) {
            return callback(err, null);
        }

        callback(null, user);
    });
};

function query(value, thing, callback) {
    var userQuery = 'SELECT * FROM users WHERE ' + thing + '= $1';
    pg.connect(pgURL, function(err, client, done) {
        if (err) {
            callback(err, null);
            return;
        }
        client.query(userQuery, [value], function(err, result) {
            done();
            if (err) {
                return callback(err, null);
            }
            if (result.rows.length === 0) {
                return callback(new errors.NotFoundError('User not found'));
            }
            callback(null, result.rows[0]);
        });
    });
}