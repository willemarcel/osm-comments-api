var config = require('../lib/config')();
var Note = require('./Note');
var queries = require('./queries');
var queue = require('d3-queue').queue;
var pg = require('pg');
require('../validators');
var validate = require('validate.js');
var errors = require('../errors');
var helpers = require('../helpers');

var notes = {};
var pgPromise = helpers.pgPromise;
var promisifyQuery = helpers.promisifyQuery;

module.exports = notes;

var pgURL = config.PostgresURL;

notes.search = function(params) {
    var parseError = validateParams(params);
    if (parseError) {
        return Promise.reject(new errors.ParseError(parseError));
    }
    var searchQuery = queries.getSearchQuery(params);
    var countQuery = queries.getCountQuery(params);

    return pgPromise(pgURL)
        .then(function (pg) {
            var query = promisifyQuery(pg.client);
            var searchProm = query(searchQuery.text, searchQuery.values);
            var countProm = query(countQuery.text, countQuery.values);

            return Promise.all([searchProm, countProm])
                .then(function (r) {
                    pg.done();
                    return r;
                });
        })
        .then(function (results) {
            var searchResult = results[0];
            var countResult = results[1];
            var notesArray = searchResult.rows.map(function (row) {
                var note = new Note(row);
                return note.getGeoJSON();
            });
            var count = countResult.rows[0].count;
            var featureCollection = {
                'type': 'FeatureCollection',
                'features': notesArray,
                'total': count
            };
            return featureCollection;
        });
};

notes.get = function(id) {
    if (!validate.isNumber(parseInt(id, 10))) {
        return Promise.reject(new errors.ParseError('Note id must be a number'));
    }
    var noteQuery = queries.getNoteQuery(id);
    var noteCommentsQuery = queries.getNoteCommentsQuery(id);
    return pgPromise(pgURL)
        .then(function (pg) {
            var query = promisifyQuery(pg.client);
            var noteProm = query(noteQuery.text, noteQuery.values);
            var noteCommentsProm = query(noteCommentsQuery.text, noteCommentsQuery.values);

            return Promise.all([noteProm, noteCommentsProm])
                .then(function (results) {
                    pg.done();
                    return results;
                });
        })
        .then(function (results) {
            var noteResult = results[0];
            if (noteResult.rows.length === 0) {
                return Promise.reject(new errors.NotFoundError('Note not found'));
            }
            var note = new Note(results[0].rows[0], results[1].rows);
            return note.getGeoJSON();
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
