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
    // wraps pg.connect into a promise, resolves
    // to client.
    pgPromise: function (url) {
        return new Promise(function (res, rej) {
            pg.connect(url, function (err, client, done) {
                if (err) {
                    return rej(err);
                }
                return res({
                    client: client,
                    done: done
                });
            });
        });
    },
    // wraps client.query into a promise
    // returns an identical function to client.query
    // except that it is thenable.
    promisifyQuery: function promisifyQuery(client) {
        return function (a, b) {
            return new Promise(function (res, rej) {
                client.query(a, b, function (err, result) {
                    if (err) return rej(err);
                    return res(result);
                });
            });
        };
    }
};