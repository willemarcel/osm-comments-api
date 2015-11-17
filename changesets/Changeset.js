var Changeset = function(data) {
    this.id = data.id;
    this.createdAt = data.created_at;
    this.closedAt = data.closed_at || null;
    this.discussionCount = data.discussion_count;
    this.isOpen = data.is_open;
    this.userID = data.user_id;
    this.userName = data.user_name;
    this.numChanges = data.num_changes;
    this.bbox = JSON.parse(data.bbox);
};

Changeset.prototype.getGeoJSON = function() {
    return {
        'type': 'Feature',
        'geometry': this.bbox,
        'properties': this.getProperties()
    };
};

Changeset.prototype.getProperties = function() {
    return {
        'id': this.id,
        'createdAt': this.createdAt,
        'closedAt': this.closedAt,
        'discussionCount': this.discussionCount,
        'isOpen': this.isOpen,
        'userID': this.userID,
        'userName': this.userName,
        'numChanges': this.numChanges
    };
};

module.exports = Changeset;