var config = require('../lib/config')();
var queue = require('d3-queue').queue;
var pg = require('pg');
var errors = require('../errors');
var users = {};

module.exports = users;

var pgURL = config.PostgresURL;

users.getName = function(name, queryParams, callback) {
    var extra = false;
    if (queryParams.extra) extra = true;
    query(name, 'name', extra, function (err, user) {
        if (err) {
            return callback(err, null);
        }

        callback(null, user);
    });
};

users.getId = function(id, query, callback) {
    var extra = false;
    if (query.extra) extra = true;
    query(id, 'id', extra, function (err, user) {
        if (err) {
            return callback(err, null);
        }

        callback(null, user);
    });
};


/*
    @param {String} value - should be either the user id or username being searched for
    @param {String} thing - either `id` or `name`, corresponding to type of value provided
    @param {Boolean} extra - whether to fetch extra attributes for the user
    @param {Function} callback - callback to call with fetched data
*/
function query(value, thing, extra, callback) {
    var userQuery = 'SELECT * FROM users WHERE ' + thing + '= $1';
    pg.connect(pgURL, function(err, client, done) {
        if (err) {
            callback(err, null);
            return;
        }
        client.query(userQuery, [value], function(err, result) {
            if (err) {
                return callback(err, null);
            }
            if (result.rows.length === 0) {
                return callback(new errors.NotFoundError('User not found'));
            }
            var user = result.rows[0];
            if (extra) {
                return fetchExtra(user, client, done, callback);
            } else {
                return callback(null, user);
            }
        });
    });
}

/*
    @param {Object} user - basic user details
    @param {PGClient Object} client - a postgres client connection instance
    @param {Function} done - function to call to close connection to db
    @param {Function} callback - function to call with basic data augmented with extra attributes
*/
function fetchExtra(user, client, done, callback) {
    var userId = user.id;
    var q = queue(3);
    var totalDiscussionsQ = 'SELECT COUNT(id) FROM changeset_comments WHERE user_id=$1';
    var discussedChangesetsQ = 'SELECT COUNT(id) FROM changesets WHERE (SELECT COUNT(id) FROM changeset_comments WHERE changeset_comments.changeset_id = changesets.id) > 0 AND changesets.discussion_count > 0 AND changesets.user_id = $1';
    q.defer(client.query.bind(client), totalDiscussionsQ, [userId]);
    q.defer(client.query.bind(client), discussedChangesetsQ, [userId]);
    q.awaitAll(function(err, results) {
        done();
        if (err) {
            return callback(err);
        }
        user.extra = {
            'total_discussions': results[0].rows[0].count,
            'changesets_with_discussions': results[1].rows[0].count
        };
        return callback(null, user);
    });
}