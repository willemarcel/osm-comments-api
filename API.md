**/api/v1** - Root of API

 - GET **/notes** Fetches notes, returned as GeoJSON. Params:
   - **from**: date to search from (as YYYY-MM-DD)
   - **to**: date to search to (as YYYY-MM-DD)
   - **users**: comma separated list of usernames - searches all notes where _users_ have participated in discussion.
   - **bbox**: BBOX string, bounding box to search for notes within
   - **sort**: Operator + Field to sort by - eg. '-created_by' will sort descending by `created_by`. Fields supported are created_by, closed_at, commented_at
   - **comment**: Text to search through all note comments for
   - **offset**: Record number to start returning results at (default=0)
   - **limit**: Number of results to return (default=20)

 - GET **/changesets** Fetches changesets, returned as GeoJSON. Params:
  - **from**: date to search from (as YYYY-MM-DD)
  - **to**: date to search to (as YYYY-MM-DD)
  - **users**: comma separate list of usernames - searches for changesets created by users in list
  - **bbox**: Bounding box to search for changesets within
  - **sort**: Operator plus field to sort by. eg. '-created_at'. Supported fields are: created_at, closed_at, discussion_count, num_changes, discussed_at
  - **comment**: Text, returns changesets where the changeset comment contains _text_
  - **discussion**: Text, returns changesets where discussion contains _text_
  - **text**: Text, returns changesets where either changeset comment or discussion contains _text_
  - **hasDiscussion**: Either 'true' or 'false': 'true' returns only changesets that contain discussions, and 'false' the inverse.
  - **isUnreplied**: Either 'true' or 'false': 'true' returns changesets where there is a discussion but the changeset author has not replied.
  - **offset**: Record number to start returning results at (default=0)
  - **limit**: Number of results to return (default=20)

