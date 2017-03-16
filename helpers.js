var turfBBoxPolygon = require('turf-bbox-polygon');
var pg = require('pg');

module.exports = {
    getPolygon: function(bboxString) {
        // TODO: Add error handling
        var points = bboxString.split(',').map(function(pt) {
            return parseFloat(pt);
        });
        return turfBBoxPolygon(points);
    },
    pgConnect: function (url, query) {
        return new Promise(function (res, rej) {
            pg.connect(url, function (err, client, done) {
                if (err) {
                    return rej(err);
                }
                client.query(query, function (err, result) {
                    done();
                    if (err) return rej(err);
                    return res(result);
                });
            });
        });
    }
};