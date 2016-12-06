var squel = require('squel').useFlavour('postgres');
var helpers = require('../helpers');

module.exports = {};

module.exports.getSearchQuery = getSearchQuery;
module.exports.getCountQuery = getCountQuery;
module.exports.getChangesetQuery = getChangesetQuery;
module.exports.getChangesetCommentsQuery = getChangesetCommentsQuery;


function getSearchQuery(params) {
    var sql = squel.select()
        .from('changesets')
        .join('changeset_comments', null, 'changesets.id = changeset_comments.changeset_id')
        .join('changeset_comments', 'last_comment', 'last_comment.changeset_id = (SELECT changeset_id FROM changeset_comments WHERE changeset_comments.changeset_id = changesets.id ORDER BY changeset_comments.timestamp DESC LIMIT 1)');
    sql = addFields(sql);
    sql = addWhereClauses(sql, params);
    sql = addOrderBy(sql, params);
    sql = addOffsetLimit(sql, params);
    return sql.toParam();
}

function getCountQuery(params) {
    var sql = squel.select()
        .from('changesets')
        .left_outer_join('changeset_comments', null, 'changesets.id = changeset_comments.changeset_id')
        .field('COUNT(DISTINCT(changesets.id))', 'count');
    sql = addWhereClauses(sql, params);
    return sql.toParam();
}

function getChangesetQuery(id) {
    var sql = squel.select()
        .from('changesets')
        .where('changesets.id = ?', id)
        .field('changesets.created_at', 'created_at')
        .field('changesets.closed_at', 'closed_at')
        .field('changesets.is_open', 'is_open')
        .field('changesets.user_id', 'user_id')
        .field('changesets.username', 'user_name')
        .field('changesets.comment', 'changeset_comment')
        .field('changesets.num_changes', 'num_changes')
        .field('changesets.discussion_count', 'discussion_count')
        .field('ST_AsGeoJSON(changesets.bbox)', 'bbox');
    return sql.toParam();
}

function getChangesetCommentsQuery(id) {
    var sql = squel.select()
        .from('changeset_comments')
        .where('changeset_id = ?', id)
        .field('changeset_comments.id', 'comment_id')
        .field('changeset_comments.timestamp', 'comment_timestamp')
        .field('changeset_comments.comment', 'comment')
        .field('changeset_comments.user_id', 'user_id')
        .field('changeset_comments.username', 'user_name');
    return sql.toParam();
}


function addFields(sql) {
    sql.field('changesets.id', 'id')
        .field('changesets.created_at', 'created_at')
        .field('changesets.closed_at', 'closed_at')
        .field('changesets.is_open', 'is_open')
        .field('changesets.user_id', 'user_id')
        .field('changesets.username', 'user_name')
        .field('changesets.comment', 'changeset_comment')
        .field('changesets.num_changes', 'num_changes')
        .field('changesets.discussion_count', 'discussion_count')
        .field('ST_AsGeoJSON(changesets.bbox)', 'bbox')
        .field('last_comment.comment', 'last_comment_comment')
        .field('last_comment.timestamp', 'last_comment_timestamp')
        .field('last_comment.user_id', 'last_comment_user_id')
        .field('last_comment.username', 'last_comment_user_name');
    return sql;
}

function addWhereClauses(sql, params) {
    var users = params.users || null;
    var from = params.from || null;
    var to = params.to || null;
    var bbox = params.bbox || null;
    var comment = params.comment || null;
    var discussion = params.discussion || null;
    var text = params.text || null;
    var isUnreplied = params.unReplied || null;
    var involves = params.involves || null;
    if (users) {
        var usersArray = users.split(',').map(function(user) {
            return user;
        });
        sql.where('changesets.username in ?', usersArray);
    }
    if (involves) {
        var involvesArray = involves.split(',').map(function(user) {
            return user;
        });
        sql.where('changeset_comments.username in ?', involvesArray); 
    }
    if (from) {
        sql.where('changesets.created_at > ?', from);
    }
    if (to) {
        sql.where('changesets.created_at < ?', to);
    }
    if (comment) {
        sql.where('to_tsvector(\'english\', changesets.comment) @@ plainto_tsquery(?)', comment);
    }
    if (discussion) {
        sql.where('to_tsvector(\'english\', changeset_comments.comment) @@ plainto_tsquery(?)', discussion);
    }
    if (text) {
        sql.where(
            squel.expr().or_begin()
                .or('to_tsvector(\'english\', changesets.comment) @@ plainto_tsquery(?)', text)
                .or('to_tsvector(\'english\', changeset_comments.comment) @@ plainto_tsquery(?)', text)
                .end()
        );
    }
    if (bbox) {
        var polygonGeojson = JSON.stringify(helpers.getPolygon(bbox).geometry);
        sql.where('ST_Intersects(changesets.bbox, ST_SetSRID(ST_GeomFromGeoJSON(?), 4326))', polygonGeojson);
    }
    if (isUnreplied && isUnreplied === 'true') {
        sql.where('changesets.is_unreplied = true');
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
    if (['created_at', 'closed_at', 'discussion_count', 'num_changes', 'discussed_at'].indexOf(field) === -1) {
        // TODO: throw ERROR
        return sql;
    }
    if (field === 'discussed_at') {
        field = 'last_comment.timestamp';
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