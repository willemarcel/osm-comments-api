var testConfig = {
    'PostgresURL': 'postgres://localhost/osm-comments-api-test'
};
var moment = require('moment');
require('../lib/config')(testConfig);

var tape = require('tape');
var users = require('../users/index');

tape('test users module', function(t) {
    t.test('test getName', function(assert) {
        users.getName('FredB')
        .then(function (result) {
            var expected = {
                'id': 1626,
                'name': 'FredB',
                'first_edit': '2013-04-24T00:00:00.000Z',
                'changeset_count': 5,
                'num_changes': 50
            };
            result.first_edit = moment(result.first_edit);
            result.first_edit = result.first_edit
                .add('minutes', result.first_edit.utcOffset())
                .toISOString();
            assert.deepEqual(result, expected, 'user module returns as expected');
            assert.end();
        })
        .catch(function (error) {
            assert.error(error, 'no error fetching user');
        });
    });

    t.test('test getID', function(assert) {
        users.getId('1626')
        .then(function (result) {
            var expected = {
                'id': 1626,
                'name': 'FredB',
                'first_edit': '2013-04-24T00:00:00.000Z',
                'changeset_count': 5,
                'num_changes': 50
            };
            console.log(result.first_edit);
            result.first_edit = moment(result.first_edit);
            result.first_edit = result.first_edit
                .add('minutes', result.first_edit.utcOffset())
                .toISOString();
            assert.deepEqual(result, expected, 'user module returns as expected');
            assert.end();
        })
        .catch(function (error) {
            assert.error(error, 'no error fetching user');
        });
    });
});
tape.onFinish(() => process.exit(0));
