var NoteComment = require('./NoteComment');

var Note = function(data, comments) {
    this.id = data.note_id;
    this.createdAt = data.created_at;
    this.closedAt = data.closed_at || null;
    // this.openedBy = data.opened_by || null;
    this.point = JSON.parse(data.point);
    if (comments) {
        this.comments = comments.map(function(comment) {
            return new NoteComment(comment);
        });
    } else {
        this.comments = null;
    }
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
        'closedAt': this.closedAt
    };
    if (this.comments) {
        props.comments = this.comments.map(function(noteComment) {
            return noteComment.getJSON();
        });
    }
    return props;
};

module.exports = Note;