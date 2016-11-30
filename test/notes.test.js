var testConfig = {
    'PostgresURL': 'postgres://localhost/osm-comments-api-test'
};

require('../lib/config')(testConfig);

var tape = require('tape');
var notesQueries = [
    require('./fixtures/notes/queries-no-params.json'),
    require('./fixtures/notes/queries-bbox.json'),
    require('./fixtures/notes/queries-from-to.json'),
    require('./fixtures/notes/queries-sort.json'),
    require('./fixtures/notes/queries-limit.json'),
    require('./fixtures/notes/queries-users.json'),
    require('./fixtures/notes/queries-comment.json'),
    require('./fixtures/notes/queries-is-open-true.json'),
    require('./fixtures/notes/queries-is-open-false.json'),
    require('./fixtures/notes/queries-sort-commented-at.json')
];

var queue = require('d3-queue').queue;
var notes = require('../notes/index');

tape('test notes module', function(assert) {
    var q = queue(10);
    notesQueries.forEach(function(query) {
        q.defer(searchNotes, assert, query);
        q.awaitAll(function() {
            assert.end();
            process.exit(0);
        });
    });
});

function searchNotes(assert, query, callback) {
    notes.search(query.params, function(err, result) {

        //the JSON.parse(JSON.stringify(result)) bit is there to format dates properly
        assert.deepEqual(JSON.parse(JSON.stringify(result)), query.geojson, query.description);
        callback();
    });
}

// function getnotes(assert, query) {
//     notes.get(query.id, function(err, result) {

//         //the JSON.parse(JSON.stringify(result)) bit is there to format dates properly
//         assert.deepEqual(JSON.parse(JSON.stringify(result)), query.geojson, query.description);
//     });
// }