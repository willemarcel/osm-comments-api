var testConfig = {
    'PostgresURL': 'postgres://localhost/osm-comments-api-test'
};

require('../lib/config')(testConfig);

var tape = require('tape');
var changes = require('../changes/index');


tape('test for user nickagee', function (assert) {
    changes.get('2016-12-31T19:00:00.000Z', '2017-03-09T06:29:59.000Z', 'nammala', null, null, result);

    function result(err, data) {
        console.log(err, data);
        assert.end();
    }
    // getchangesets(assert,changesetQueryDetailed);

});

tape.onFinish(() => process.exit(0));
