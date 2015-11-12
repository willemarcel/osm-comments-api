var express = require('express');
var pg = require('pg');
var queue = require('queue-async');
var pgURL = require('./lib/config')().PostgresURL;
var server = module.exports = express();
var notesQuery = require('./query/notes');
var Note = require('./lib/Note');

server.get('/api/v1/notes', function(req, res) {
    var notesQ = notesQuery(req.query);
    console.log('notesQ', notesQ);
    var sql = notesQ.text;
    var params = notesQ.values;
    var q = queue(5);
    pg.connect(pgURL, function(err, client, done) {
        q.defer(client.query.bind(client), sql, params);
        q.awaitAll(function(err, results) {
            if (err) {
                console.log('query error', err);
            }
            var notesResult = results[0];
            var notesGeoJSON = notesResult.rows.map(function(row) {
                console.log('row', row);
                var note = new Note(row);
                console.log('note', note);
                return note.getGeoJSON();
            });
            var featureCollection = {
                'type': 'FeatureCollection',
                'features': notesGeoJSON
            };
            res.json(featureCollection);
        });
    });

});