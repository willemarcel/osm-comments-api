var NoteComment = require('./NoteComment');

var Note = function(data, comments) {
    this.id = data.note_id;
    this.createdAt = data.created_at;
    this.closedAt = data.closed_at || null;
    this.note = data.note;
    this.userName = data.user_name || null;
    this.lastCommentComment = data.last_comment_comment || null;
    this.lastCommentTimestamp = data.last_comment_timestamp || null;
    this.lastCommentUserName = data.last_comment_user_name || null;
    this.lastCommentUserID = data.last_comment_user_id || null;
    this.lastCommentAction = data.last_comment_action || null;
    this.commentCount = data.comment_count;
    // this.openedBy = data.opened_by || null;
    this.point = JSON.parse(data.point);
    if (comments) {
        this.comments = comments.map(function(comment) {
            return new NoteComment(comment);
        });
    } else {
        this.comments = null;
    }
    return this;
};

Note.prototype.getGeoJSON = function() {
    return {
        'type': 'Feature',
        'geometry': this.point,
        'properties': this.getProperties()
    };
};

Note.prototype.getProperties = function() {
    var props = {
        'id': this.id,
        'createdAt': this.createdAt,
        'closedAt': this.closedAt,
        'note': this.note,
        'userName': this.userName,
        'lastCommentComment': this.lastCommentComment,
        'lastCommentTimestamp': this.lastCommentTimestamp,
        'lastCommentUserName': this.lastCommentUserName,
        'lastCommentUserID': this.lastCommentUserID,
        'lastCommentAction': this.lastCommentAction,
        'commentCount': this.commentCount
    };
    if (this.comments) {
        props.comments = this.comments.map(function(noteComment) {
            return noteComment.getJSON();
        });
    }
    return props;
};

module.exports = Note;
