# osm-comments-api
Expose a RESTful API for OSM Notes and Changeset Comments.

### Setup

 - Get some data into your database, see https://github.com/mapbox/osm-comments-parser

 - Run `npm install`

 - Define an env var called `OSM_COMMENTS_POSTGRES_URL` eg `export OSM_COMMENTS_POSTGRES_URL='postgres://localhost/osm-comments'`

 - Run server with `node run-server.js`

 - Visit for eg. `http://localhost:8888/api/v1/notes` in your browser to see some JSON


### Use as module

  - You can also import and use this in your node project as a module. A simple example:

    var api = require('osm-comments-api');
    api.listen(8888);

 ### Test

 - Set an environment variabled called `TEST_PG_USER` with your postgres username
 - Run `npm test`