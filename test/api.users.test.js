process.env.OSM_COMMENTS_POSTGRES_URL = 'postgres://' + process.env.TEST_PG_USER + '@localhost/osm-comments-api-test';

var api = require('../api');
var tape = require('tape');
var http = require('http');

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

tape('start server', function(assert) {
    api.listen(20009, function(err) {
        if (err) throw err;
        assert.pass('server listening on 20009');
        assert.end();
    });
});

tape('run API test for users', function(assert) {
    get('/api/v1/users/name/FredB', function(err, res) {
        assert.ifError(err, 'call to user API does not error');
        console.log(res);
        var expected = {'id':1626,'name':'FredB','first_edit':'2013-04-23T18:30:00.000Z','changeset_count':5,'num_changes':50};
        assert.deepEqual(JSON.parse(res), expected, 'API response for user end-point as expected');
        assert.end();
    });
});

tape.onFinish(() => process.exit(0));
