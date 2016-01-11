var testConfig = {
    'PostgresURL': 'postgres://localhost/osm-comments-api-test'
};
require('../lib/config')(testConfig);
var testList = require('./fixtures/notes/test_list.json');
var fs = require('fs');
var path = require('path');
var notes = require('../notes');
var basePath = path.join(__dirname, 'fixtures', 'notes');

testList.forEach(function(t) {
    var fixturePath = path.join(basePath, t.fixture);
    console.log('reading file ' + fixturePath);
    var fixture = JSON.parse(fs.readFileSync(fixturePath));
    var fn;
    var param;
    if (fixture.params) {
        fn = notes.search;
        param = fixture.params;
    } else {
        fn = notes.get;
        param = fixture.id;
    }
    fn(param, function(err, geojson) {
        console.log('geojson returned', geojson);
        fixture.geojson = geojson;
        fs.writeFileSync(fixturePath, JSON.stringify(fixture, null, 2));
        console.log('written file ' + fixturePath);
    });
});
