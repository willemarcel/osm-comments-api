var config = {
    'PostgresURL': process.env.OSM_COMMENTS_POSTGRES_URL || 'postgres://postgres@localhost/osm-comments'
};
require('./lib/config')(config);

var express = require('express');
var notes = require('./notes/index');
var changesets = require('./changesets/index');
var users = require('./users/index');
var changes = require('./changes/index');
var cors = require('cors');
var errors = require('mapbox-error');
var ErrorHTTP = require('mapbox-error').ErrorHTTP;
var customErrors = require('./errors');
var moment = require('moment');
var server = module.exports = express();

server.use(cors());

server.get('/', function(req, res) {
    res.json({'status': 'ok'});
});

server.get('/api/v1/notes', function(req, res, next) {
    notes.search(req.query)
        .then(function(geojson) {
            res.json(geojson);
        })
        .catch(next);
});

server.get('/api/v1/changesets', function(req, res, next) {
    changesets.search(req.query)
        .then(function(geojson) {
            res.json(geojson);
        })
        .catch(next);
});

server.get('/api/v1/notes/:id', function(req, res, next) {
    notes.get(req.params.id)
        .then(function(geojson) {
            res.json(geojson);
        })
        .catch(next);
});

server.get('/api/v1/changesets/:id', function(req, res, next) {
    changesets.get(req.query)
        .then(function (geojson) {
            res.json(geojson);
        })
        .catch(next);
});

server.get('/api/v1/users/name/:name', function(req, res, next) {
    users.getName(req.params.name)
        .then(function(json) {
            res.json(json);
        })
        .catch(next);
});

server.get('/api/v1/users/id/:id', function(req, res, next) {
    users.getId(req.params.id)
        .then(function(json) {
            res.json(json);
        })
        .catch(next);
});

server.get('/api/v1/stats/', function(req, res, next) {
    var to = req.query.to || moment().toISOString();
    var from = req.query.from || moment().subtract(1, 'hours').toISOString();
    var users = req.query.users || false;
    var tags = req.query.tags || false;
    var bbox = req.query.bbox || false;
    changes.get(from, to, users, tags, bbox)
        .then(function(d) {res.json(d);})
        .catch(next);
});

server.use(function(err, req, res, next) {
    if (err instanceof customErrors.ParseError) {
        next(new ErrorHTTP('Invalid request: ' + err.message, 422));
    } else if (err instanceof customErrors.NotFoundError) {
        next(new ErrorHTTP('Not found: ' + err.message, 404));
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
