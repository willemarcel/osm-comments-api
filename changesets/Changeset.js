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
        'numChanges': this.numChanges
    };
    if (this.comments) {
        props.comments = this.comments.map(function(comment) {
            return comment.getJSON();
        });
    }
    return props;
};

module.exports = Changeset;