var squel = require('squel').useFlavour('postgres');
var moment = require('moment');

module.exports = function(params) {
    var from = params.from || null;
    var to = params.to || null;
    var users = params.users || null;
    var bbox = params.bbox || null;
    var offset = params.offset || 0;
    var limit = params.limit || 20;
    var sql = squel.select()
        .from('notes')
        .left_outer_join('users', 'u1', 'notes.opened_by = u1.id')
        .field('notes.id', 'note_id')
        .field('notes.created_at', 'created_at')
        .field('notes.closed_at', 'closed_at')
        .field('ST_AsGeoJSON(notes.point)', 'point')
        .field('u1.id', 'user_id')
        .field('u1.name', 'user_name')
        .offset(Number(offset))
        .limit(Number(limit));
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
    return sql.toParam();
};

