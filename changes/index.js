var config = require('../lib/config')();
var queue = require('d3-queue').queue;
var pg = require('pg');
var errors = require('../errors');

var changes = {};

module.exports = changes;
var pgURL = config.PostgresURL;

changes.get = function(from, to, users, tags, callback) {
    var changesQuery = 'SELECT * FROM stats WHERE change_at > $1 AND change_at < $2';
    pg.connect(pgURL, function(err, client, done) {
        if (err) {
            callback(err, null);
            return;
        }
        client.query(changesQuery, [from, to], function(err, result) {
            done();
            if (err) {
                return callback(err, null);
            }
            if (result.rows.length === 0) {
                return callback(new errors.NotFoundError('No records found'));
            }
            callback(null, result.rows);
        });
    });
};