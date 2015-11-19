var express = require('express');
var notes = require('./notes/index');
var changesets = require('./changesets/index');
var cors = require('cors');
var errors = require('mapbox-error');
var customErrors = require('./errors');

var server = module.exports = express();

server.use(cors());

server.get('/api/v1/notes', function(req, res, next) {
    notes.search(req.query, function(err, geojson) {
        if (err) {
            return next(err);
        }
        res.json(geojson);
        next();
    });
});

server.get('/api/v1/changesets', function(req, res, next) {
    changesets.search(req.query, function(err, geojson) {
        if (err) {
            return next(err);
        }
        res.json(geojson);
        next();
    });
});

server.get('/api/v1/notes/:id', function(req, res, next) {
    notes.get(req.params.id, function(err, geojson) {
        if (err) {
            return next(err);
        }
        res.json(geojson);
        next();
    });
});

server.get('/api/v1/changesets/:id', function(req, res, next) {
    changesets.get(req.params.id, function(err, geojson) {
        if (err) {
            return next(err);
        }
        res.json(geojson);
        next();
    });
});

server.use(function(err, req, res, next) {
    if (err instanceof customErrors.ParseError) {
        console.log(err);
        res.status(400).send({'message': err.message});
    } else if (err instanceof customErrors.NotFoundError) {
        res.status(404).send({'message': err.message});
    } else {
        next(err);
    }
});

server.use(errors.showError);
server.use(errors.notFound);

// server.use(function(err, req, res, next) {
//     console.log(err);
//     res.status(500).send(JSON.stringify(err));
// });
