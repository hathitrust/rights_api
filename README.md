# Proposed Rights Database API

## Initial Setup
```bash
git clone https://github.com/hathitrust/rights_api
cd rights_api
docker-compose build
docker-compose run --rm web bundle install
docker-compose up -d
```

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

## TODO

See DEV-990

- Remove last vestiges of `rights_database` gem
- `/rights?...` query parameters other than HTID (dates, for example)
- `/rights_log?...` query parameters other than HTID (dates, for example)
- Results paging

