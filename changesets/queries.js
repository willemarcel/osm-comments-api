var squel = require('squel').useFlavour('postgres');
var moment = require('moment');
var helpers = require('../helpers');

module.exports = {};

module.exports.getSearchQuery = getSearchQuery;
module.exports.getCountQuery = getCountQuery;

function getSearchQuery(params) {
    var sql = squel.select()
        .from('changesets')
        .join('users', null, 'changesets.user_id = users.id')
        .left_outer_join('changeset_comments', null, 'changesets.id = changeset_comments.changeset_id');
    sql = addFields(sql);
    sql = addWhereClauses(sql, params);
    sql = addGroupBy(sql);
    sql = addOffsetLimit(sql, params);
    return sql.toParam();
}

function getCountQuery(params) {
    var sql = squel.select()
        .from('changesets')
        .join('users', null, 'changesets.user_id = users.id')
        .field('COUNT(changesets.id)', 'count');
    sql = addWhereClauses(sql, params);
    return sql.toParam();
}

function addGroupBy(sql) {
    sql.group('changesets.id')
        .group('users.name');
    return sql;
}

function addFields(sql) {
    sql.field('changesets.id', 'id')
        .field('COUNT(changeset_comments.id)', 'discussion_count')
        .field('changesets.created_at', 'created_at')
        .field('changesets.closed_at', 'closed_at')
        .field('changesets.is_open', 'is_open')
        .field('changesets.user_id', 'user_id')
        .field('users.name', 'user_name')
        .field('changesets.num_changes', 'num_changes')
        .field('ST_AsGeoJSON(changesets.bbox)', 'bbox');
    return sql;
}

function addWhereClauses(sql, params) {
    var users = params.users || null;
    var from = params.from || null;
    var to = params.to || null;
    if (users) {
        var usersArray = users.split(',').map(function(user) {
            return user.trim();
        });
        sql.where('users.name in ?', usersArray);
    }
    if (from) {
        sql.where('changesets.created_at > ?', from);
    }
    if (to) {
        sql.where('changesets.created_at < ?', to);
    }
    return sql;
}

function addOffsetLimit(sql, params) {
    var offset = params.offset || 0;
    var limit = params.limit || 20;
    sql.offset(Number(offset))
        .limit(Number(limit));
    return sql;
}