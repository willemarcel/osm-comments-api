var ChangesetComment = require('./ChangesetComment');
var ChangesetTag = require('./ChangesetTag');

var Changeset = function(data, comments, tags) {
    this.id = data.id;
    this.createdAt = data.created_at;
    this.closedAt = data.closed_at || null;
    this.discussionCount = data.discussion_count;
    this.isOpen = data.is_open;
    this.userID = data.user_id;
    this.userName = data.user_name;
    this.numChanges = data.num_changes;
    this.bbox = JSON.parse(data.bbox);
    this.changesetComment = data.changeset_comment || '';
    if (comments) {
        this.comments = comments.map(function(comment) {
            return new ChangesetComment(comment);
        });
    } else {
        this.comments = null;
    }
    if (tags) {
        this.tags = tags.map(function(tag) {
            return new ChangesetTag(tag);
        });
    } else {
        this.tags = null;
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
        'changesetComment': this.changesetComment
    };
    if (this.comments) {
        props.comments = this.comments.map(function(comment) {
            return comment.getJSON();
        });
    }
    if (this.tags) {
        props.tags = this.tags.map(function(tag) {
            return tag.getJSON();
        });
    }
    return props;
};

module.exports = Changeset;