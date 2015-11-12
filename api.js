var express = require('express');
var pg = require('pg');
var queue = require('queue-async');
var notesQueries = require('./query/notes');
var Note = require('./lib/Note');
var pgURL = require('./lib/config')().PostgresURL;

var server = module.exports = express();

server.get('/api/v1/notes', function(req, res) {
    var searchQuery = notesQueries.getSearchQuery(req.query);
    // console.log('notesQ', notesQ);
    // var searchSQL = searchSQL.text;
    // var searchParams = searchSQL.values;
    var countQuery = notesQueries.getCountQuery(req.query);
    console.log('queries', searchQuery, countQuery);
    var q = queue(5);
    pg.connect(pgURL, function(err, client, done) {
        q.defer(client.query.bind(client), searchQuery.text, searchQuery.values);
        q.defer(client.query.bind(client), countQuery.text, countQuery.values);
        q.awaitAll(function(err, results) {
            if (err) {
                console.log('query error', err);
            }

            var searchResult = results[0];
            var countResult = results[1];
            var notesArray = searchResult.rows.map(function(row) {
                // console.log('row', row);
                var note = new Note(row);
                // console.log('note', note);
                return note.getGeoJSON();
            });
            var count = countResult.rows[0].count;
            var featureCollection = {
                'type': 'FeatureCollection',
                'features': notesArray,
                'total': count
            };
            res.json(featureCollection);
        });
    });
});