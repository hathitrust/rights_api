# Proposed Rights Database API

## Initial Setup
```bash
git clone https://github.com/hathitrust/rights_api
cd rights_api
docker-compose build
docker-compose run --rm web bundle install
docker-compose up -d
```

## Naming Conventions

- The Rights Database is replete with abbreviations. Field and table names exposed
  by this API are de-abbreviated:
  - "attr" becomes "attribute"
  - "dscr" becomes "description"
  - "stmt" becomes "statement"
- Spurious prefixes are eliminated:
  - `a_attr` and `a_access_profile` become `attr` and `access_profile` (`attr` is further de-abbreviated as above)
- For the sake of brevity, `rights_current` (the star of the show) is exposed as `rights` in URLs.

## Examples

### "All Items" Queries

Note: there is a default limit of 1000 items in the returned dataset.
Pagination is not yet implemented, but none of the test tables are anywhere near that large.

```
http://localhost:4567/v1/access_profiles
http://localhost:4567/v1/access_statements      # access_stmts table
http://localhost:4567/v1/access_statements_map  # access_stmts_map table
http://localhost:4567/v1/attributes
http://localhost:4567/v1/reasons
http://localhost:4567/v1/rights/                # rights_current table
http://localhost:4567/v1/rights_log/
http://localhost:4567/v1/sources/
```

### "One Item" Queries

Note: rights (`rights_current`) and `rights_log` take HTIDs, `access_statements` takes a
`stmt_key`, `access_statements_map` takes a composite `a_attr`.`a_access_profile` key.
All other take a standard integer key.

```
http://localhost:4567/v1/access_profiles/1
http://localhost:4567/v1/access_statements/pd             # access_stmts table
http://localhost:4567/v1/access_statements_map/pd.google  # access_stmts_map table
http://localhost:4567/v1/attributes/1
http://localhost:4567/v1/reasons/1
http://localhost:4567/v1/rights/test.pd_google            # rights_current table
http://localhost:4567/v1/rights_log/test.pd_google
http://localhost:4567/v1/sources/1
```

See `lib/rights_api/app.rb` for all of the Sinatra routes.

## Results

All API results, even 404s (which should only occur with a bad Sinatra route) should return
the same general JSON structure. Here's the empty variant:

```JSON
{
  "total":0,
  "start":0,
  "end":0,
  "data":[]
}

```
`total` is the number of query results. `start` and `end` are the one-based indexes of the
current `OFFSET, LIMIT` slice. (The zeroes here are the empty result special case.)
`data` is an array of hashes, one hash per row.

Here's a truncated result from `http://localhost:4567/v1/access_profiles`:

```JSON
{
  "total":4,
  "start":1,
  "end":4,
  "data":[
    {
      "id":1,
      "name":"open",
      "description":"Unrestricted image and full-volume download (e.g. Internet Archive)"
    },
    ...
  ]
}

```

## Testing
The test suite is divided into unit and integration tests which can be run separately to give some orthogonality in checking for coverage gaps.
```
# Full test suite
docker-compose run --rm test
# Standard
docker-compose run --rm test bundle exec standardrb
# Unit
docker-compose run --rm test bundle exec rspec spec/unit
# Integration
docker-compose run --rm test bundle exec rspec spec/integration
```

## TODO

See DEV-990

- Remove last vestiges of `rights_database` gem
- `/rights?...` query parameters other than HTID (dates, for example)
- `/rights_log?...` query parameters other than HTID (dates, for example)
- Results paging

