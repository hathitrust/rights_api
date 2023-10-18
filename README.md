# Proposed Rights Database API

## Initial Setup
```bash
git clone https://github.com/hathitrust/rights_api
docker-compose build
docker-compose run --rm web bundle install
docker-compose up
```

## Examples

Visit `http://localhost:4567/` for a usage summary.
```
http://localhost:4567/v1/attributes
http://localhost:4567/v1/reasons
http://localhost:4567/v1/rights/test.und_open
http://localhost:4567/v1/rights_log/test.und_open
```
See `lib/rights_api/app.rb` for all of the Sinatra routes.

## TODO
- Remove last vestiges of rights_database gem
- `/rights?...` query parameters other than HTID (dates, for example)
- `/rights_log?...` query parameters other than HTID (dates, for example)
- Results paging

