var config = require('../lib/config')();
var errors = require('../errors');
var helpers = require('../helpers');

var users = {};

module.exports = users;

var pgURL = config.PostgresURL;
var pgPromise = helpers.pgPromise;
var promisifyQuery = helpers.promisifyQuery;

users.getName = function(name, queryParams) {
    var extra = false;
    if (queryParams && queryParams.extra) extra = true;
    return query(name, 'name', extra);
};

users.getId = function (id, queryParams) {
    var extra = false;
    if (queryParams && queryParams.extra) extra = true;
    return query(id, 'id', extra);
};


/*
    @param {String} value - should be either the user id or username being searched for
    @param {String} thing - either `id` or `name`, corresponding to type of value provided
    @param {Boolean} extra - whether to fetch extra attributes for the user
*/
function query(value, thing, extra) {
    var userQuery = 'SELECT * FROM users WHERE ' + thing + '= $1';
    var firstEditQuery = 'SELECT created_at FROM changesets WHERE user_id=$1 ORDER BY created_at LIMIT 1';
    return pgPromise(pgURL)
        .then(function (pg) {
            var queryPromise = promisifyQuery(pg.client);
            var userQueryProm = queryPromise(userQuery, [value]);

            return userQueryProm.then(function (result) {
                if (result.rows.length === 0) {
                    return Promise.reject(new errors.NotFoundError('User not found'));
                }
                var user = result.rows[0];
                var firstEditProm = queryPromise(firstEditQuery, [user.id]);
                return firstEditProm.then(function (result) {
                    var created_at = result.rows[0].created_at;
                    user.first_edit = created_at;
                    if (extra) {
                        return fetchExtra(user, queryPromise);
                    }
                    return user;
                });
            })
            .then(function (result) {
                pg.done();
                return result;
            })
            .catch(function (e) {
                pg.done();
                return Promise.reject(e);
            });
        });
}

/*
    @param {Object} user - basic user details
    @param {queryPromise}  promisified query which is identical to client.query
                    except that it is thenable
*/
function fetchExtra(user, queryPromise) {
    var userId = user.id;
    var totalDiscussionsQ = 'SELECT COUNT(id) FROM changeset_comments WHERE user_id=$1';
    var discussedChangesetsQ = 'SELECT COUNT(id) FROM changesets WHERE (SELECT COUNT(id) FROM changeset_comments WHERE changeset_comments.changeset_id = changesets.id) > 0 AND changesets.discussion_count > 0 AND changesets.user_id = $1';
    var mappingDaysQ = 'SELECT COUNT(DISTINCT(date_trunc(\'day\', created_at))) FROM changesets WHERE user_id=$1';
    var editFrequency = 'SELECT date_trunc(\'day\', closed_at) as day, COUNT(id) FROM changesets WHERE user_id=$1 GROUP BY day ORDER BY day;'

    var promises = [
        queryPromise(totalDiscussionsQ, [userId]),
        queryPromise(discussedChangesetsQ, [userId]),
        queryPromise(mappingDaysQ, [userId]),
        queryPromise(editFrequency, [userId])
    ];
  
    return Promise.all(promises)
        .then(function (results) {
            user.extra = {
                'total_discussions': results[0].rows[0].count,
                'changesets_with_discussions': results[1].rows[0].count,
                'mapping_days': results[2].rows[0].count,
                'edit_frequency': results[3].rows
            };
            return user;
        });
}