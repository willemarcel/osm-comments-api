var config = require('../lib/config')();
var queue = require('d3-queue').queue;
var pg = require('pg');
var errors = require('../errors');

var users = {};

module.exports = users;

var pgURL = config.PostgresURL;

users.get = function(name, callback) {
    var userQuery = 'SELECT * FROM users WHERE name = $1';
    pg.connect(pgURL, function(err, client, done) {
        if (err) {
            callback(err, null);
            return;
        }
        client.query(userQuery, [name], function(err, result) {
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
};