process.env.OSM_COMMENTS_POSTGRES_URL = 'postgres://' + process.env.TEST_PG_USER + '@localhost/osm-comments-api-test';

var api = require('../api');
var tape = require('tape');
var exec = require('child_process').exec;
var queue = require('d3-queue').queue;
var path = require('path');
var http = require('http');
var db = path.resolve(__dirname, 'db.sh');
var testsList = require('./fixtures/notes/test_list.json');
var server;

// Simple GET function
function get(path, callback) {
    http.get('http://localhost:20009' + path, function(res) {
        var body = '';
        res.on('error', callback);
        res.on('data', function(d) { body += d; });
        res.on('end', function() {
            callback(null, body, res);
        });
    }).on('error', callback);
}

// Wrapper to provide database isolation between tests
function test(name, options, callback) {
    if (typeof options === 'function') {
        callback = options;
        options = undefined;
    }

    tape(name, options, function(assert) {
        var end = assert.end.bind(assert);
        var q = queue(1);

        q.defer(exec, db + ' before');
        q.defer(function(next) {
            assert.end = next;
            callback(assert);
        });
        q.defer(exec, db + ' after');
        q.awaitAll(function(err) {
            if (err) return end(err);
            end();
        });
    });
}

tape('drop db', function(assert) {
    exec('dropdb osm-comments-api-test || :', function(err) {
        if (err) throw err;
        assert.end();
    });
});

tape('create db', function(assert) {
    exec('createdb osm-comments-api-test', function(err) {
        if (err) throw err;
        assert.end();
    });
});

tape('start server', function(assert) {
    server = api.listen(20009, function(err) {
        if (err) throw err;
        assert.pass('server listening on 20009');
        assert.end();
    });
});

test('run API test for users', function(assert) {
    get('/api/v1/users/FredB', function(err, res) {
        assert.ifError(err, 'call to user API does not error');
        var expected = {'id':1626,'name':'FredB','first_edit':'2013-04-23T18:30:00.000Z','changeset_count':5,'num_changes':50};
        assert.deepEqual(JSON.parse(res), expected, 'API response for user end-point as expected');
        assert.end();
    });
});