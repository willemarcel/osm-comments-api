var config = require('../lib/config')();
var Changeset = require('./Changeset');
var queries = require('./queries');
var helpers = require('../helpers');
require('../validators');
var validate = require('validate.js');
var errors = require('../errors');
var pgPromise = helpers.pgPromise;
var promisifyQuery = helpers.promisifyQuery;

var changesets = {};

module.exports = changesets;

var pgURL = config.PostgresURL;

changesets.search = function(params) {
    var parseError = validateParams(params);
    if (parseError) {
        return Promise.reject(new errors.ParseError(parseError));
    }
    var searchQuery = queries.getSearchQuery(params);
    var countQuery = queries.getCountQuery(params);
    console.log('searchQ', searchQuery);
    console.log('countQ', countQuery);

    return pgPromise(pgURL)
        .then(function (pg) {
            var query = promisifyQuery(pg.client);
            var searchProm = query(searchQuery.text, searchQuery.values);
            var countProm = query(countQuery.text, countQuery.values);

            return Promise.all([searchProm, countProm])
                .then(function (r) {
                    pg.done();
                    return r;
                })
                .catch(function (e) {
                    pg.done();
                    return Promise.reject(e);
                });
        })
        .then(processSearchResults);
};

changesets.get = function(id) {
    if (!validate.isNumber(parseInt(id, 10))) {
        return Promise.reject(new errors.ParseError('Changeset id must be a number'));
    }
    var changesetQuery = queries.getChangesetQuery(id);
    var changesetCommentsQuery = queries.getChangesetCommentsQuery(id);

    return pgPromise(pgURL)
        .then(function (pg) {
            var query = promisifyQuery(pg.client);
            var changesetProm = query(changesetQuery.text, changesetQuery.values);
            var changesetCommentsProm = query(changesetCommentsQuery.text, changesetCommentsQuery.values);

            return Promise.all([changesetProm, changesetCommentsProm])
                .then(function (results) {
                    pg.done();
                    return results;
                })
                .catch(function (e) {
                    pg.done();
                    return Promise.reject(e);
                });
        })
        .then(function (results) {
            var changesetResult = results[0];
            if (changesetResult.rows.length === 0) {
                return Promise.reject(new errors.NotFoundError('Changeset not found'));
            }
            var changeset = new Changeset(results[0].rows[0], results[1].rows);
            return changeset.getGeoJSON();
        });
};

function processSearchResults(results) {
    var searchResult = results[0];
    var countResult = results[1];

    var changesetsArray = searchResult.rows.map(function (row) {
        var changeset = new Changeset(row);
        return changeset.getGeoJSON();
    });
    var count;
    if (countResult.rows.length > 0) {
        count = countResult.rows[0].count;
    } else {
        count = 0;
    }
    var featureCollection = {
        'type': 'FeatureCollection',
        'features': changesetsArray,
        'total': count
    };
    return featureCollection;
}

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