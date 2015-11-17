var config = require('../lib/config')();
var Changeset = require('./Changeset');
var queries = require('./queries');
var queue = require('queue-async');
var pg = require('pg');

var changesets = {};

module.exports = changesets;

var pgURL = config.PostgresURL;

changesets.search = function(params, callback) {
    var searchQuery = queries.getSearchQuery(params);
    var countQuery = queries.getCountQuery(params);
    console.log('queries', searchQuery, countQuery);
    var q = queue(2);
    pg.connect(pgURL, function(err, client, done) {
        if (err) {
            callback(err, null);
            return;
        }
        q.defer(client.query.bind(client), searchQuery.text, searchQuery.values);
        q.defer(client.query.bind(client), countQuery.text, countQuery.values);
        q.awaitAll(function(err, results) {
            done();
            if (err) {
                console.log('query error', err);
                callback(err, null);
                return;
            }
            var searchResult = results[0];
            var countResult = results[1];
            var changesetsArray = searchResult.rows.map(function(row) {
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
            callback(null, featureCollection);
        });
    });
};

changesets.get = function(id, callback) {
    var changesetQuery = queries.getChangesetQuery(id);
    var changesetCommentsQuery = queries.getChangesetCommentsQuery(id);
    var q = queue(2);
    console.log('queries', changesetQuery, changesetCommentsQuery);
    pg.connect(pgURL, function(err, client, done) {
        if (err) {
            callback(err, null);
            return;
        }
        q.defer(client.query.bind(client), changesetQuery.text, changesetQuery.values);
        q.defer(client.query.bind(client), changesetCommentsQuery.text, changesetCommentsQuery.values);
        q.awaitAll(function(err, results) {
            done();
            if (err) {
                console.log('query error', err);
                callback(err, null);
                return;
            }
            var changesetResult = results[0];
            if (changesetResult.rows.length === 0) {
                throw Error('Changeset not found');
            }
            console.log('results', results);
            var changeset = new Changeset(results[0].rows[0], results[1].rows);
            callback(null, changeset.getGeoJSON());
        });
    });
};