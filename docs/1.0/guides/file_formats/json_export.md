---
layout: docu
redirect_from:
- /docs/archive/1.0/guides/import/json_export
title: JSON Export
---

To export the data from a table to a JSON file, use the `COPY` statement:

```sql
COPY tbl TO 'output.json';
```

The result of queries can also be directly exported to a JSON file:

```sql
COPY (SELECT * FROM tbl) TO 'output.json';
```

For additional options, see the [`COPY` statement documentation]({% link docs/1.0/sql/statements/copy.md %}).