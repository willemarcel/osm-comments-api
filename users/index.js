var config = require('../lib/config')();
var errors = require('../errors');
var helpers = require('../helpers');

var users = {};

module.exports = users;

var pgURL = config.PostgresURL;
var pgPromise = helpers.pgPromise;
var promisifyQuery = helpers.promisifyQuery;

users.getName = function(name) {
    return query(name, 'name');
};

users.getId = function(id) {
    return query(id, 'id');
};

function query(value, thing) {
    var userQuery = 'SELECT * FROM users WHERE ' + thing + '= $1';
    return pgPromise(pgURL)
        .then(function (pg) {
            var query = promisifyQuery(pg.client);
            return query(userQuery, [value])
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
                return Promise.reject(new errors.NotFoundError('User not found'));
            }
            return result.rows[0];
        });
}