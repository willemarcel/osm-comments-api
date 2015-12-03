
var NoteComment = function(data) {
    this.id = data.comment_id;
    this.userID = data.user_id;
    this.action = data.comment_action;
    this.timestamp = data.comment_timestamp;
    this.comment = data.comment;
    this.userName = data.user_name;
};

NoteComment.prototype.getJSON = function() {
    return {
        'id': this.id,
        'userID': this.userID,
        'userName': this.userName,
        'action': this.action,
        'timestamp': this.timestamp,
        'comment': this.comment
    };
};

module.exports = NoteComment;