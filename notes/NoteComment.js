
var NoteComment = function(data) {
    this.id = data.comment_id;
    this.userID = data.user_id;
    this.action = data.comment_action;
    this.timestamp = data.comment_timestamp;
    this.comment = data.comment;
};

NoteComment.prototype.getJSON = function() {
    return {
        'id': this.id,
        'userID': this.userID,
        'action': this.action,
        'timestamp': this.timestamp,
        'comment': this.comment
    };
};

module.exports = NoteComment;