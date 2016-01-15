var squel = require('squel').useFlavour('postgres');
var helpers = require('../helpers');

module.exports = {};

module.exports.getSearchQuery = getSearchQuery;
module.exports.getCountQuery = getCountQuery;
module.exports.getNoteQuery = getNoteQuery;
module.exports.getNoteCommentsQuery = getNoteCommentsQuery;

function getSearchQuery(params) {
    var sql = squel.select()
        .from('notes')
        .join('note_comments', 'last_comment', 'last_comment.id = (SELECT id FROM note_comments WHERE note_comments.note_id = notes.id ORDER BY note_comments.timestamp DESC LIMIT 1)')
        .join('note_comments', null, 'note_comments.note_id = notes.id')
        .join('note_comments', 'opening_comment', 'opening_comment.note_id = notes.id AND opening_comment.action=\'opened\'')
        .left_outer_join('users', 'opening_user', 'opening_user.id = opening_comment.user_id')
        .left_outer_join('users', 'last_user', 'last_user.id = (SELECT user_id FROM note_comments WHERE note_comments.note_id = notes.id ORDER BY note_comments.timestamp DESC LIMIT 1)');
       
    sql = addFields(sql);
    sql = addWhereClauses(sql, params);
    sql = addGroupBy(sql);
    sql = addOrderBy(sql, params);
    sql = addOffsetLimit(sql, params);
    return sql.toParam();
}

function getCountQuery(params) {
    var sql = squel.select()
        .from('notes')
        .join('note_comments', null, 'notes.id = note_comments.note_id')
        .field('count(distinct(notes.id))');
    sql = addWhereClauses(sql, params);
    return sql.toParam();
}

function getNoteQuery(id) {
    var sql = squel.select()
        .from('notes')
        .join('note_comments', 'opening_comment', 'opening_comment.note_id = notes.id AND opening_comment.action=\'opened\'')
        .left_outer_join('users', 'opening_user', 'opening_user.id = opening_comment.user_id')
        .where('notes.id = ?', id);
    sql = addFields(sql);
    return sql.toParam();
}

function getNoteCommentsQuery(id) {
    var sql = squel.select()
        .from('note_comments')
        .left_outer_join('users', null, 'note_comments.user_id = users.id')
        .where('note_id = ?', id)
        .field('note_comments.id', 'comment_id')
        .field('users.id', 'user_id')
        .field('users.name', 'user_name')
        .field('note_comments.action', 'comment_action')
        .field('note_comments.timestamp', 'comment_timestamp')
        .field('note_comments.comment', 'comment')
        .order('note_comments.timestamp', true);
    return sql.toParam();
}

function addFields(sql) {
    sql.field('notes.id', 'note_id')
        .field('notes.created_at', 'created_at')
        .field('notes.closed_at', 'closed_at')
        .field('opening_comment.comment', 'note')
        .field('opening_user.name', 'user_name')
        .field('last_comment.comment', 'last_comment_comment')
        .field('last_comment.timestamp', 'last_comment_timestamp')
        .field('last_comment.action', 'last_comment_action')
        .field('last_user.name', 'last_comment_user_name')
        .field('(SELECT count(note_comments.id) FROM note_comments WHERE note_comments.note_id = notes.id)', 'comment_count')
        .field('ST_AsGeoJSON(notes.point)', 'point')
        .distinct();
    return sql;
}

function addGroupBy(sql) {
    sql.group('last_comment.comment')
        .group('last_comment.timestamp')
        .group('last_comment.action')
        .group('notes.id')
        .group('opening_comment.id')
        .group('opening_user.id')
        .group('last_user.id');
    return sql;
}

function addWhereClauses(sql, params) {
    var from = params.from || null;
    var to = params.to || null;
    var users = params.users || null;
    var bbox = params.bbox || null;
    var comment = params.comment || null;
    var isOpen = params.isOpen || null;
    if (bbox) {
        var polygonGeojson = JSON.stringify(helpers.getPolygon(bbox).geometry);
        sql.where('ST_Within(notes.point, ST_SetSRID(ST_GeomFromGeoJSON(?), 4326))', polygonGeojson);
    }
    if (from) {
        sql.where('created_at > ?', from);
    }
    if (to) {
        sql.where('created_at < ?', to);
    }
    if (isOpen === 'true') {
        sql.where('closed_at IS NULL');
    } else if (isOpen === 'false') {
        sql.where('closed_at IS NOT NULL');
    }
    if (users) {
        sql.join('users', null, 'note_comments.user_id = users.id');
        var usersArray = users.split(',').map(function(user) {
            return user;
        });
        sql.where('users.name in ?', usersArray);
    }
    if (comment) {
        sql.where('to_tsvector(\'english\', note_comments.comment) @@ plainto_tsquery(?)', comment);
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
    if (['created_at', 'closed_at', 'commented_at'].indexOf(field) === -1) {
        // TODO: throw ERROR
        return sql;
    }
    if (field === 'commented_at') {
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
