var config = require('../lib/config')();
var Note = require('./Note');
var queries = require('./queries');
var queue = require('queue-async');
var pg = require('pg');
require('../validators');
var validate = require('validate.js');
var errors = require('../errors');
var notes = {};

module.exports = notes;

var pgURL = config.PostgresURL;

notes.search = function(params, callback) {
    var parseError = validateParams(params);
    if (parseError) {
        return callback(new errors.ParseError(parseError));
    }
    var searchQuery = queries.getSearchQuery(params);
    var countQuery = queries.getCountQuery(params);
    var q = queue(5);
    pg.connect(pgURL, function(err, client, done) {
        if (err) {
            return callback(err, null);
        }
        q.defer(client.query.bind(client), searchQuery.text, searchQuery.values);
        q.defer(client.query.bind(client), countQuery.text, countQuery.values);
        q.awaitAll(function(err, results) {
            done();
            if (err) {
                return callback(err, null);
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

notes.get = function(id, callback) {
    if (!validate.isNumber(parseInt(id, 10))) {
        return callback(new errors.ParseError('Note id must be a number'));
    }
    var noteQuery = queries.getNoteQuery(id);
    var noteCommentsQuery = queries.getNoteCommentsQuery(id);
    var q = queue(2);
    pg.connect(pgURL, function(err, client, done) {
        if (err) {
            return callback(err, null);
        }
        q.defer(client.query.bind(client), noteQuery.text, noteQuery.values);
        q.defer(client.query.bind(client), noteCommentsQuery.text, noteCommentsQuery.values);
        q.awaitAll(function(err, results) {
            done();
            if (err) {
                return callback(err, null);
            }
            var noteResult = results[0];
            if (noteResult.rows.length === 0) {
                return callback(new errors.NotFoundError('Note not found'));
            }
            var note = new Note(results[0].rows[0], results[1].rows);
            callback(null, note.getGeoJSON());
        });
    });
};

function validateParams(params) {
    var constraints = {
        'from': {
            'presence': false,
            'datetime': true
        },
        'to': {
            'presence': false,
            'datetime': true
        },
        'bbox': {
            'presence': false,
            'bbox': true
        }
    };
    var errs = validate(params, constraints);
    if (errs) {
        var errMsg = Object.keys(errs).map(function(key) {
            return errs[key][0];
        }).join(', ');
        return errMsg;
    }
    return null;
}
