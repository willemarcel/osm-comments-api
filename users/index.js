var config = require('../lib/config')();
var errors = require('../errors');
var helpers = require('../helpers');

var users = {};

module.exports = users;

var pgURL = config.PostgresURL;
var pgPromise = helpers.pgPromise;
var promisifyQuery = helpers.promisifyQuery;

users.getName = function(name, queryParams, callback) {
    var extra = false;
	if (queryParams.extra) extra = true;
    return query(name, 'name', extra);
}

users.getId = function(id, query, callback) {
    var extra = false;
    if (query.extra) extra = true;
    query(id, 'id', extra);
};


/*
    @param {String} value - should be either the user id or username being searched for
    @param {String} thing - either `id` or `name`, corresponding to type of value provided
    @param {Boolean} extra - whether to fetch extra attributes for the user
*/
function query(value, thing, extra) {
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
            var user = result.rows[0];
			if (extra) {
				 return fetchExtra(user, client);
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
    var mappingDaysQ = "SELECT COUNT(DISTINCT(date_trunc('day', created_at))) FROM changesets WHERE user_id=$1";
    q.defer(client.query.bind(client), totalDiscussionsQ, [userId]);
    q.defer(client.query.bind(client), discussedChangesetsQ, [userId]);
    q.defer(client.query.bind(client), mappingDaysQ, [userId]);
    q.awaitAll(function(err, results) {
        done();
        if (err) {
            return callback(err);
        }
        user.extra = {
            'total_discussions': results[0].rows[0].count,
            'changesets_with_discussions': results[1].rows[0].count,
            'mapping_days': results[2].rows[0].count
        };
        return callback(null, user);
    });
}