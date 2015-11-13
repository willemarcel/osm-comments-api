var express = require('express');
var notes = require('./notes/index');

var server = module.exports = express();

server.get('/api/v1/notes', function(req, res, next) {
    notes.search(req.query, function(err, geojson) {
        res.json(geojson);
        next();
    });
});
