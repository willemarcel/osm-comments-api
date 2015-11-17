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
    sql = addOrderBy(sql, params);
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
    var bbox = params.bbox || null;
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
    if (bbox) {
        var polygonGeojson = JSON.stringify(helpers.getPolygon(bbox).geometry);
        sql.where('ST_Intersects(changesets.bbox, ST_SetSRID(ST_GeomFromGeoJSON(?), 4326))', polygonGeojson);
    }
    return sql;
}

function addOrderBy(sql, params) {
    var sort = params.sort || '-created_at';
    var operator = sort.substring(0, 1);
    var field = sort.substring(1);
    if (['+', '-'].indexOf(operator) === -1) {
        // TODO: throw ERROR
        return sql;
    }
    if (['created_at', 'closed_at', 'discussion_count', 'num_changes'].indexOf(field) === -1) {
        // TODO: throw ERROR
        return sql;
    }
    var isAscending = operator === '+';
    sql.order(field, isAscending);
    return sql;
}

function addOffsetLimit(sql, params) {
    var offset = params.offset || 0;
    var limit = params.limit || 20;
    sql.offset(Number(offset))
        .limit(Number(limit));
    return sql;
}