var ChangesetComment = function(data) {
    this.id = data.comment_id;
    this.timestamp = data.comment_timestamp;
    this.comment = data.comment;
    this.userID = data.user_id;
    this.userName = data.user_name;
    return this;
};

ChangesetComment.prototype.getJSON = function() {
    return {
        'id': this.id,
        'timestamp': this.timestamp,
        'comment': this.comment,
        'userID': this.userID,
        'userName': this.userName
    };
};

module.exports = ChangesetComment;