var express = require('express');
var notes = require('./notes/index');
var changesets = require('./changesets/index');
var cors = require('cors');

var server = module.exports = express();

server.use(cors());

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

server.get('/api/v1/notes/:id', function(req, res, next) {
    notes.get(req.params.id, function(err, geojson) {
        res.json(geojson);
        next();
    });
});

server.get('/api/v1/changesets/:id', function(req, res, next) {
    changesets.get(req.params.id, function(err, geojson) {
        res.json(geojson);
        next();
    });
});
