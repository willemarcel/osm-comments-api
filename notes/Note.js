
var Note = function(data) {
    this.id = data.note_id;
    this.createdAt = data.created_at;
    this.closedAt = data.closed_at || null;
    // this.openedBy = data.opened_by || null;
    this.point = JSON.parse(data.point);
};

Note.prototype.getGeoJSON = function() {
    return {
        'type': 'Feature',
        'geometry': this.point,
        'properties': this.getProperties()
    };
};

Note.prototype.getProperties = function() {
    return {
        'id': this.id,
        'createdAt': this.createdAt,
        'closedAt': this.closedAt
    };
};

module.exports = Note;