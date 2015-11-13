var config = require('../lib/config')();
var Note = require('./Note');
var queries = require('./queries');
var queue = require('queue-async');
var pg = require('pg');

var notes = {};

module.exports = notes;

var pgURL = config.PostgresURL;

notes.search = function(params, callback) {
    var searchQuery = queries.getSearchQuery(params);
    var countQuery = queries.getCountQuery(params);
    console.log('queries', searchQuery, countQuery);
    var q = queue(5);
    pg.connect(pgURL, function(err, client, done) {
        if (err) {
            callback(err, null);
            return;
        }
        q.defer(client.query.bind(client), searchQuery.text, searchQuery.values);
        q.defer(client.query.bind(client), countQuery.text, countQuery.values);
        q.awaitAll(function(err, results) {
            if (err) {
                console.log('query error', err);
                callback(err, null);
                return;
            }
            var searchResult = results[0];
            var countResult = results[1];
            var notesArray = searchResult.rows.map(function(row) {
                var note = new Note(row);
                return note.getGeoJSON();
            });
            var count = countResult.rows[0].count;
            var featureCollection = {
                'type': 'FeatureCollection',
                'features': notesArray,
                'total': count
            };
            callback(null, featureCollection);
        });
    });
};

