process.env.OSM_COMMENTS_POSTGRES_URL = 'postgres://' + process.env.TEST_PG_USER + '@localhost/osm-comments-api-test';

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

test('get changesets within the bounding box [-80,-80,60,60]', function(assert) {
    var expectedchangesets = require('./fixtures/changesets/queries-bbox.json').geojson;
    get('/api/v1/changesets?bbox=-80,-80,60,60', function(err, body, res) {
        assert.ifError(err, 'success');
        assert.equal(res.statusCode, 200, 'expected HTTP status');
        assert.deepEqual(JSON.parse(body), expectedchangesets, 'expected response');
        assert.end();
    });
});

test('get a detailed reponse for the changeset with ID 34721797', function(assert) {
    var expectedchangesets = require('./fixtures/changesets/queries-detailed.json').geojson;
    get('/api/v1/changesets/34721797', function(err, body, res) {
        assert.ifError(err, 'success');
        assert.equal(res.statusCode, 200, 'expected HTTP status');
        assert.deepEqual(JSON.parse(body), expectedchangesets, 'expected response');
        assert.end();
    });
});

test('get changesets from 2013-04-01 to 2014-12-01', function(assert) {
    var expectedchangesets = require('./fixtures/changesets/queries-from-to.json').geojson;
    get('/api/v1/changesets?from=2013-04-01&to=2014-12-01', function(err, body, res) {
        assert.ifError(err, 'success');
        assert.equal(res.statusCode, 200, 'expected HTTP status');
        assert.deepEqual(JSON.parse(body), expectedchangesets, 'expected response');
        assert.end();
    });
});

test('get all changesets from server, but show only the first two, by setting limit=3', function(assert) {
    var expectedchangesets = require('./fixtures/changesets/queries-limit.json').geojson;
    get('/api/v1/changesets?limit=3', function(err, body, res) {
        assert.ifError(err, 'success');
        assert.equal(res.statusCode, 200, 'expected HTTP status');
        assert.deepEqual(JSON.parse(body), expectedchangesets, 'expected response');
        assert.end();
    });
});

test('list changesets', function(assert) {
    var expectedchangesets = require('./fixtures/changesets/queries-no-params.json').geojson;
    get('/api/v1/changesets', function(err, body, res) {
        assert.ifError(err, 'success');
        assert.equal(res.statusCode, 200, 'expected HTTP status');
        assert.deepEqual(JSON.parse(body), expectedchangesets, 'expected response');
        assert.end();
    });
});



test('sort queries in the ascending order', function(assert) {
    var expectedchangesets = require('./fixtures/changesets/queries-sort.json').geojson;
    get('/api/v1/changesets?sort=%2Bcreated_at', function(err, body, res) {
        assert.ifError(err, 'success');
        assert.equal(res.statusCode, 200, 'expected HTTP status');
        assert.deepEqual(JSON.parse(body), expectedchangesets, 'expected response');
        assert.end();
    });
});

test('get changesets related to users ansuta Armire bjoern_m Cyclizine and wanda987', function(assert) {
    var expectedchangesets = require('./fixtures/changesets/queries-users.json').geojson;
    get('/api/v1/changesets?users=ansuta,Armire,bjoern_m,Cyclizine,wanda987', function(err, body, res) {
        assert.ifError(err, 'success');
        assert.equal(res.statusCode, 200, 'expected HTTP status');
        assert.deepEqual(JSON.parse(body), expectedchangesets, 'expected response');
        assert.end();
    });
});

test('get changesets with comment containing the word Hamburg', function(assert) {
    var expectedchangesets = require('./fixtures/changesets/queries-comment.json').geojson;
    get('/api/v1/changesets?comment=Hamburg', function(err, body, res) {
        assert.ifError(err, 'success');
        assert.equal(res.statusCode, 200, 'expected HTTP status');
        assert.deepEqual(JSON.parse(body), expectedchangesets, 'expected response');
        assert.end();
    });
});

test('get changesets with discussion containing the word test', function(assert) {
    var expectedchangesets = require('./fixtures/changesets/queries-discussion.json').geojson;
    get('/api/v1/changesets?discussion=test', function(err, body, res) {
        assert.ifError(err, 'success');
        assert.equal(res.statusCode, 200, 'expected HTTP status');
        assert.deepEqual(JSON.parse(body), expectedchangesets, 'expected response');
        assert.end();
    });
});

test('get changesets sorted by -discussed_at', function(assert) {
    var expectedchangesets = require('./fixtures/changesets/queries-sort-discussed-at.json').geojson;
    get('/api/v1/changesets?sort=-discussed_at', function(err, body, res) {
        assert.ifError(err, 'success');
        assert.equal(res.statusCode, 200, 'expected HTTP status');
        assert.deepEqual(JSON.parse(body), expectedchangesets, 'expected response');
        assert.end();
    });    
});

test('get changesets filtered by unReplied=true', function(assert) {
    var expectedchangesets = require('./fixtures/changesets/queries-is-unreplied.json').geojson;
    get('/api/v1/changesets?isUnreplied=true', function(err, body, res) {
        assert.ifError(err, 'success');
        assert.equal(res.statusCode, 200, 'expected HTTP status');
        assert.deepEqual(JSON.parse(body), expectedchangesets, 'expected response');
        assert.end();
    });    
});

//Tests for invalid queries
test('get changeset that does not exist', function(assert) {
    get('/api/v1/changesets/123456789', function(err, body, res) {
        assert.ifError(err, 'success');
        assert.deepEqual(JSON.parse(body), { message: 'Not found: Changeset not found' }, 'expected error message');
        assert.equal(res.statusCode, 404, 'expected status');
        assert.end();
    });
});

test('get invalid changeset id', function(assert) {
    get('/api/v1/changesets/ventriloquism', function(err, body, res) {
        assert.ifError(err, 'success');
        assert.deepEqual(JSON.parse(body), { message: 'Invalid request: Changeset id must be a number' }, 'expected error message');
        assert.equal(res.statusCode, 422, 'expected status');
        assert.end();
    });
});

test('get results for invalid from date', function(assert) {
    get('/api/v1/changesets?from=strings&to=2015-09-08', function(err, body, res) {
        assert.ifError(err, 'success');
        assert.deepEqual(JSON.parse(body), { message: 'Invalid request: From must be a valid date' }, 'expected error message');
        assert.equal(res.statusCode, 422, 'expected status');
        assert.end();
    });
});

test('get results for invalid to date', function(assert) {
    get('/api/v1/changesets?from=2015-09-08&to=strings', function(err, body, res) {
        assert.ifError(err, 'success');
        assert.deepEqual(JSON.parse(body), { message: 'Invalid request: To must be a valid date' }, 'expected error message');
        assert.equal(res.statusCode, 422, 'expected status');
        assert.end();
    });
});

test('get results for invalid bounding box', function(assert) {
    get('/api/v1/changesets?bbox=a,1,2,3', function(err, body, res) {
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
