#!/usr/bin/env bash

if [ "$1" == "before" ]; then
  psql osm-comments-api-test < test/fixtures/initial_data.sql
elif [ "$1" == "after" ]; then
  psql osm-comments-api-test -c "delete from changeset_comments;"
  psql osm-comments-api-test -c "delete from changeset_tags;"
  psql osm-comments-api-test -c "delete from changesets;"
  psql osm-comments-api-test -c "delete from note_comments;"
  psql osm-comments-api-test -c "delete from notes;"
  psql osm-comments-api-test -c "delete from users;"
else
  exit 1
fi
