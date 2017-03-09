var testConfig = {
    'PostgresURL': 'postgres://localhost/osm-comments-api-test'
};

require('../lib/config')(testConfig);

var tape = require('tape');
var changes = require('../changes/index');


tape('test for user jdbajar0', function (assert) {
    changes.get('2016-12-31T19:00:00.000Z', '2017-03-09T06:29:59.000Z', 'jdbajar0', null, null, result);
    function result(err, data) {
        assert.deepEqual(data['2017-02-01T05:00:00.000Z'].jdbajar0.nodes, {c : 60, d: 0, m:0});
        assert.deepEqual(data['2017-02-01T05:00:00.000Z'].jdbajar0.ways, { c: 15, d: 0, m: 0 });
        assert.deepEqual(data['2017-02-01T05:00:00.000Z'].jdbajar0.changesets.length, 3);
        assert.end();
    }
});
tape('test for user Rightful49', function (assert) {
    changes.get('2016-12-31T19:00:00.000Z', '2017-03-09T06:29:59.000Z', 'Rightful49', null, null, result);
    function result(err, data) {
        assert.deepEqual(data['2017-02-01T05:00:00.000Z'].Rightful49.nodes, { c: 5, d: 0, m: 0 });
        assert.deepEqual(data['2017-02-01T05:00:00.000Z'].Rightful49.ways, { c: 5, d: 0, m: 5 });
        assert.deepEqual(data['2017-02-01T05:00:00.000Z'].Rightful49.changesets.length, 1);
        assert.end();
    }
});
tape('test for multiusers', function (assert) {
    changes.get('2016-12-31T19:00:00.000Z', '2017-03-09T06:29:59.000Z', 'Rightful49,nickagee', null, null, result);
    function result(err, data) {
        assert.true(data['2017-02-01T05:00:00.000Z'].Rightful49);
        assert.true(data['2017-02-01T05:00:00.000Z'].nickagee);
        assert.end();
    }
});

tape('test for user nickagee in all data', function (assert) {
    changes.get('2016-12-31T19:00:00.000Z', '2017-03-09T06:29:59.000Z', null, null, null, result);
    function result(err, data) {
        assert.true(data['2017-02-01T05:00:00.000Z'].nickagee);
        assert.deepEqual(data['2017-02-01T05:00:00.000Z'].nickagee.nodes, { c: 1520, d: 0, m: 130 });
        assert.deepEqual(data['2017-02-01T05:00:00.000Z'].nickagee.ways, { c: 345, d: 0, m: 20 });
        assert.deepEqual(data['2017-02-01T05:00:00.000Z'].nickagee.relations, { c: 0, d: 0, m: 0 });
        assert.deepEqual(data['2017-02-01T05:00:00.000Z'].nickagee.changesets.length, 1);
        assert.deepEqual(data['2017-02-01T05:00:00.000Z'].nickagee.tags_created, { highway: { residential: 5 }, 'source:geomatry': { Bing: 5 } });
        assert.deepEqual(data['2017-02-01T05:00:00.000Z'].nickagee.tags_modified, { building: { yes: 5 } });
        assert.end();
    }
});

tape('test for specific timerange', function (assert) {
    changes.get('2017-02-02T19:00:00.000Z', '2017-02-07T19:00:00.000Z', null, null, null, result);
    function result(err, data) {
        assert.false(data['2017-02-01T05:00:00.000Z']);
        assert.true(data['2017-02-06T09:00:00.000Z']);
        assert.end();
    }
});

tape('test for multidata', function (assert) {
    changes.get('2017-02-02T19:00:00.000Z', '2017-03-07T19:00:00.000Z', null, null, null, result);
    function result(err, data) {
        assert.true(data['2017-02-06T09:00:00.000Z'].BharataHS_laimport);
        assert.equal(data['2017-02-06T09:00:00.000Z'].BharataHS_laimport.ways.c, 462);
        assert.deepEqual(data['2017-02-06T09:00:00.000Z'].BharataHS_laimport.nodes, {c: 7038, d: 0, m:0});
        assert.end();
    }
});

tape('test for total nodes', function (assert) {
    changes.get('2017-02-02T19:00:00.000Z', '2017-03-07T19:00:00.000Z', null, null, null, result);
    function result(err, data) {
        var d = data['2017-02-06T09:00:00.000Z'];
        var sum = Object.keys(d).filter(u => d[u] && d[u].nodes).reduce((s, u) => s + d[u].nodes.c + d[u].nodes.m + d[u].nodes.d , 0);
        assert.equal(sum, 43285);
        assert.end();
    }
});

tape('test for total ways', function (assert) {
    changes.get('2017-02-02T19:00:00.000Z', '2017-03-07T19:00:00.000Z', null, null, null, result);
    function result(err, data) {
        var d = data['2017-02-06T09:00:00.000Z'];
        var sum = Object.keys(d).filter(u => d[u] && d[u].ways).reduce((s, u) => s + d[u].ways.c + d[u].ways.m + d[u].ways.d, 0);
        assert.equal(sum, 2941);
        assert.end();
    }
});

tape('test for total relations', function (assert) {
    changes.get('2017-02-02T19:00:00.000Z', '2017-03-07T19:00:00.000Z', null, null, null, result);
    function result(err, data) {
        var d = data['2017-02-06T09:00:00.000Z'];
        var sum = Object.keys(d).filter(u => d[u] && d[u].relations).reduce((s, u) => s + d[u].relations.c + d[u].relations.m + d[u].relations.d, 0);
        assert.equal(sum, 32);
        assert.end();
    }
});

tape('test for total number changesets', function (assert) {
    changes.get('2017-02-02T19:00:00.000Z', '2017-03-07T19:00:00.000Z', null, null, null, result);
    function result(err, data) {
        var d = data['2017-02-06T09:00:00.000Z'];
        var sum = Object.keys(d).filter(u => d[u] && d[u].changesets).reduce((s, u) => s + d[u].changesets.length, 0);
        assert.equal(sum, 164);
        assert.end();
    }
});


tape.onFinish(() => process.exit(0));
