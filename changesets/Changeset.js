var ChangesetComment = require('./ChangesetComment');

var Changeset = function(data, comments) {
    this.id = data.id;
    this.createdAt = data.created_at;
    this.closedAt = data.closed_at || null;
    this.discussionCount = data.discussion_count;
    this.isOpen = data.is_open;
    this.userID = data.user_id;
    this.userName = data.user_name;
    this.numChanges = data.num_changes;
    this.bbox = JSON.parse(data.bbox);
    this.lastCommentComment = data.last_comment_comment || null;
    this.lastCommentTimestamp = data.last_comment_timestamp || null;
    this.lastCommentUserName = data.last_comment_user_name || null;
    this.lastCommentUserID = data.last_comment_user_id || null;
    this.changesetComment = data.changeset_comment || '';
    if (comments) {
        this.comments = comments.map(function(comment) {
            return new ChangesetComment(comment);
        });
    } else {
        this.comments = null;
    }
    return this;
};

Changeset.prototype.getGeoJSON = function() {
    return {
        'type': 'Feature',
        'geometry': this.bbox,
        'properties': this.getProperties()
    };
};

Changeset.prototype.getProperties = function() {
    var props =  {
        'id': this.id,
        'createdAt': this.createdAt,
        'closedAt': this.closedAt,
        'discussionCount': this.discussionCount,
        'isOpen': this.isOpen,
        'userID': this.userID,
        'userName': this.userName,
        'numChanges': this.numChanges,
        'changesetComment': this.changesetComment,
        'lastCommentComment': this.lastCommentComment,
        'lastCommentTimestamp': this.lastCommentTimestamp,
        'lastCommentUserName': this.lastCommentUserName,
        'lastCommentUserID': this.lastCommentUserID
    };
    if (this.comments) {
        props.comments = this.comments.map(function(comment) {
            return comment.getJSON();
        });
    }
    return props;
};

module.exports = Changeset;