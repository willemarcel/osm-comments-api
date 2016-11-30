var testConfig = {
    'PostgresURL': 'postgres://localhost/osm-comments-api-test'
};

require('../lib/config')(testConfig);

var tape = require('tape');
var changesetsQueries = [
    require('./fixtures/changesets/queries-no-params.json'),
    require('./fixtures/changesets/queries-bbox.json'),
    require('./fixtures/changesets/queries-from-to.json'),
    require('./fixtures/changesets/queries-sort.json'),
    require('./fixtures/changesets/queries-limit.json'),
    require('./fixtures/changesets/queries-users.json'),
    require('./fixtures/changesets/queries-comment.json'),
    require('./fixtures/changesets/queries-discussion.json'),
    require('./fixtures/changesets/queries-sort-discussed-at.json'),
    require('./fixtures/changesets/queries-is-unreplied.json'),
    require('./fixtures/changesets/queries-text.json')
];

// var changesetQueryDetailed = require('./fixtures/changesets/queries-detailed.json');

var queue = require('d3-queue').queue;
var changesets = require('../changesets/index');


tape('test changesets module', function(assert) {
    var q = queue(10);
    changesetsQueries.forEach(function(query) {

        q.defer(searchchangesets, assert, query);

        q.awaitAll(function() {
            assert.end();
            process.exit(0);
        });
    });

    // getchangesets(assert,changesetQueryDetailed);

});


function searchchangesets(assert, query, callback) {
    changesets.search(query.params, function(err, result) {

        //the JSON.parse(JSON.stringify(result)) bit is there to format dates properly
        assert.deepEqual(JSON.parse(JSON.stringify(result)), query.geojson, query.description);
        callback();
    });
}

// function getchangesets(assert, query) {
//     changesets.get(query.id, function(err, result) {

//         //the JSON.parse(JSON.stringify(result)) bit is there to format dates properly
//         assert.deepEqual(JSON.parse(JSON.stringify(result)), query.geojson, query.description);
//     });
// }