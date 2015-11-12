var logger = require('fastlog')();
var argv = require('minimist')(process.argv.slice(2));

var config = {
    'PostgresURL': process.env.OSM_COMMENTS_POSTGRES_URL || 'postgres://postgres@localhost/osm-comments'
};

require('./lib/config')(config);

var port = argv.port || 8888;

var api = require('./api');

api.listen(port);

logger.info("Started api at localhost:%s", port);
