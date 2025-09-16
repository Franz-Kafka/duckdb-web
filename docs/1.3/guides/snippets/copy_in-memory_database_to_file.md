---
layout: docu
title: Copying an In-Memory Database to a File
---

Imagine the following situation – you started DuckDB in in-memory mode but would like to persist the state of your database to disk.
To achieve this, **attach to a new disk-based database** and use the [`COPY FROM DATABASE ... TO` command]({% link docs/1.3/sql/statements/copy.md %}#copy-from-database--to):

```sql
ATTACH 'my_database.db';
COPY FROM DATABASE memory TO my_database;
DETACH my_database;
```

> Ensure that the disk-based database file does not exist before attaching to it.
