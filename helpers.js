var turfBBoxPolygon = require('turf-bbox-polygon');

module.exports = {
    'getPolygon': function(bboxString) {
        // TODO: Add error handling
        var points = bboxString.split(',').map(function(pt) {
            return parseFloat(pt);
        });
        return turfBBoxPolygon(points);
    }
};