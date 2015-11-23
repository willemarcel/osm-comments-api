# osm-comments-api
Expose a RESTful API for OSM Notes and Changeset Comments. _Work in progress_.

### Setup

 - Get some data into your database, see https://github.com/mapbox/osm-comments-parser

 - Run `npm install`

 - Define an env var called `OSM_COMMENTS_POSTGRES_URL` eg `export OSM_COMMENTS_POSTGRES_URL='postgres://localhost/osm-comments'`

 - Run server with `node index.js`

 - Visit for eg. `http://localhost:8888/api/v1/notes` in your browser to see some JSON