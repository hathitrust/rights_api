# Proposed Rights Database API

## Initial Setup
```bash
git clone https://github.com/hathitrust/rights_api
docker-compose up
```

## Examples

Visit `http://localhost:4567/` for a usage summary.
```
http://localhost:4567/attributes
http://localhost:4567/reasons
http://localhost:4567/rights?htid=test.und_open

```

## TODO
- `rights_log` queries (requires changes to the rights_database gem)
- `db-image` seeds for `rights_log` (currently empty)
- `/rights?...` query parameters other than HTID (dates, for example)
- Results paging
- Add versioning to API routes
- Think carefully about exposing `rights_current.user` and `rights_current.note` in a public API
