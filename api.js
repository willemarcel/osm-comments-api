var express = require('express');
var notes = require('./notes/index');
var changesets = require('./changesets/index');

var server = module.exports = express();

server.get('/api/v1/notes', function(req, res, next) {
    notes.search(req.query, function(err, geojson) {
        res.json(geojson);
        next();
    });
});

server.get('/api/v1/changesets', function(req, res, next) {
    changesets.search(req.query, function(err, geojson) {
        res.json(geojson);
        next();
    });
});
