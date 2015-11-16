var squel = require('squel').useFlavour('postgres');
var moment = require('moment');

module.exports = {};

module.exports.getSearchQuery = getSearchQuery;
module.exports.getCountQuery = getCountQuery;

function getSearchQuery(params) {
    var sql = squel.select()
        .from('notes');
    sql = addFields(sql);
    sql = addWhereClauses(sql, params);
    sql = addOrderBy(sql, params);
    sql = addOffsetLimit(sql, params);
    return sql.toParam();
}

function getCountQuery(params) {
    var sql = squel.select()
        .from('notes')
        .field('count(notes.id)');
    sql = addWhereClauses(sql, params);
    return sql.toParam();
}

function addFields(sql) {
    sql.field('notes.id', 'note_id')
        .field('notes.created_at', 'created_at')
        .field('notes.closed_at', 'closed_at')
        .field('ST_AsGeoJSON(notes.point)', 'point');
    return sql;
}

function addWhereClauses(sql, params) {
    var from = params.from || null;
    var to = params.to || null;
    var users = params.users || null;
    var bbox = params.bbox || null;
    if (from) {
        sql.where('created_at > ?', from);
    }
    if (to) {
        sql.where('created_at < ?', to);
    }
    if (users) {
        sql.join('note_comments', null, 'notes.id = note_comments.note_id')
            .join('users', null, 'note_comments.user_id = users.id');
        var usersArray = users.split(',').map(function(user) {
            return user.trim();
        });
        sql.where('users.name in ?', usersArray);
    }
    sql.distinct();
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
    if (['created_at', 'closed_at'].indexOf(field) === -1) {
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
