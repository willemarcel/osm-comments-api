var ChangesetTag = function(tag) {
    this.key = tag.key;
    this.value = tag.value;
};

ChangesetTag.prototype.getJSON = function() {
    return {
        'key': this.key,
        'value': this.value
    };
};

module.exports = ChangesetTag;