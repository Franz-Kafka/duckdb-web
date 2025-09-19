---
layout: docu
redirect_from:
- /docs/extensions/troubleshooting
- /docs/extensions/troubleshooting/
title: Troubleshooting of Extensions
---

You might be visiting this page directed via a DuckDB error message, similar to:
```sql
INSTALL non_existing;
```
```console
HTTP Error:
Failed to download extension "non_existing" at URL "http://extensions.duckdb.org/v1.4.0/osx_arm64/non_existing.duckdb_extension.gz" (HTTP 404)

Candidate extensions: "inet", "encodings", "core_functions", "sqlite_scanner", "postgres_scanner"
For more info, visit https://duckdb.org/docs/stable/extensions/troubleshooting?version=v1.4.0&platform=osx_arm64&extension=non_existing
```

There are multiple scenarios for which an extensions might not be available in a given extension repository at a given time:
* extension have not been uploaded yet, here some delay after a given release date might be expected. Consider checking the issues at duckdb/duckdb or duckdb/community-extensions, or creating one yourself.
* extension is available, but in a different repository, try for example `INSTALL <name> FROM core;` or `INSTALL <name> FROM community;` or `INSTALL <name> FROM core_nightly;` (check https://duckdb.org/docs/stable/extensions/installing_extensions#extension-repositories) 
* networking issues, so extension exists at the endpoint but it's not reachable from your local DuckDB. Here you can try visiting the given URL via a browser directly pasting the link from the error message in the search bar.

If you are on a development version of DuckDB, that is any version for which `PRAGMA version` returns a library_version not starting with a `v`, then extensions might not be available anymore on the default extension repository.

Consider raising an issue on duckdb/duckdb if in doubt.
