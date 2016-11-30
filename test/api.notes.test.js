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

test('run API tests for notes', function(assert) {
    var q = queue(5);
    testsList.forEach(function(t) {
        q.defer(runAPITest, assert, t);    
    });
    q.awaitAll(function() {
        assert.end();
    });
});

function runAPITest(assert, testObj, callback) {
    var basePath = './fixtures/notes/';
    var expected = require(basePath + testObj.fixture);
    get(testObj.url, function(err, body, res) {
        assert.ifError(err, testObj.description + ': success');
        assert.equal(res.statusCode, 200, testObj.description + ': status 200');
        assert.deepEqual(JSON.parse(body), expected.geojson, testObj.description);
        callback();
    });
}

//Tests for invalid queries
// test('get note that does not exist', function(assert) {
//     get('/api/v1/notes/123456789', function(err, body, res) {
//         assert.ifError(err, 'success');
//         assert.deepEqual(JSON.parse(body), { message: 'Not found: Note not found' }, 'expected error message');
//         assert.equal(res.statusCode, 404, 'expected status');
//         assert.end();
//     });
// });

// test('get invalid note id', function(assert) {
//     get('/api/v1/notes/bananas', function(err, body, res) {
//         assert.ifError(err, 'success');
//         assert.deepEqual(JSON.parse(body), { message: 'Invalid request: Note id must be a number' }, 'expected error message');
//         assert.equal(res.statusCode, 422, 'expected status');
//         assert.end();
//     });
// });

test('get results for invalid from date', function(assert) {
    get('/api/v1/notes?from=strings&to=2015-09-08', function(err, body, res) {
        assert.ifError(err, 'success');
        assert.deepEqual(JSON.parse(body), { message: 'Invalid request: From must be a valid date' }, 'expected error message');
        assert.equal(res.statusCode, 422, 'expected status');
        assert.end();
    });
});

test('get results for invalid to date', function(assert) {
    get('/api/v1/notes?from=2015-09-08&to=strings', function(err, body, res) {
        assert.ifError(err, 'success');
        assert.deepEqual(JSON.parse(body), { message: 'Invalid request: To must be a valid date' }, 'expected error message');
        assert.equal(res.statusCode, 422, 'expected status');
        assert.end();
    });
});

test('get results for invalid bounding box', function(assert) {
    get('/api/v1/notes?bbox=a,1,2,3', function(err, body, res) {
        assert.ifError(err, 'success');
        assert.deepEqual(JSON.parse(body), { message: 'Invalid request: Bbox not a valid bbox string' }, 'expected error message');
        assert.equal(res.statusCode, 422, 'expected status');
        assert.end();
    });
});

tape('close server', function(assert) {
    server.close(function(err) {
        if (err) throw err;
        assert.pass('server closed');
        assert.end();
        process.exit(0);
    });
});
