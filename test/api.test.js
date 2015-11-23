require('../lib/config')({
    PostgresURL: 'postgres://' + process.env.TEST_PG_USER + '@localhost/osm-comments-api-test'
});

var api = require('../api');
var tape = require('tape');
var exec = require('child_process').exec;
var queue = require('queue-async');
var path = require('path');
var http = require('http');
var db = path.resolve(__dirname, 'db.sh');
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

test('list notes', function(assert) {
    var expectedNotes = require('./fixtures/notes/queries.json')[0].geojson;
    get('/api/v1/notes', function(err, body, res) {
        assert.ifError(err, 'success');
        assert.equal(res.statusCode, 200, 'expected HTTP status');
        assert.deepEqual(JSON.parse(body), expectedNotes, 'expected response');
        assert.end();
    });
});

test('get note that does not exist', function(assert) {
    get('/api/v1/notes/123456789', function(err, body, res) {
        assert.ifError(err, 'success');
        assert.deepEqual(JSON.parse(body), { message: 'Not found: Note not found' }, 'expected error message');
        assert.equal(res.statusCode, 404, 'expected status');
        assert.end();
    });
});

test('get invalid note id', function(assert) {
    get('/api/v1/notes/bananas', function(err, body, res) {
        assert.ifError(err, 'success');
        assert.deepEqual(JSON.parse(body), { message: 'Invalid request: Note id must be a number' }, 'expected error message');
        assert.equal(res.statusCode, 422, 'expected status');
        assert.end();
    });
});

tape('close server', function(assert) {
    server.close(function(err) {
        if (err) throw err;
        assert.pass('server closed');
        assert.end();
    });
});
