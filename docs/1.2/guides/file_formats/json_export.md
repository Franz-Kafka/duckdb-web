---
layout: docu
title: JSON Export
---

To export the data from a table to a JSON file, use the `COPY` statement:

```sql
COPY tbl TO 'output.json';
```

The result of queries can also be directly exported to a JSON file:

```sql
COPY (SELECT * FROM range(3) tbl(n)) TO 'output.json';
```

```text
{"n":0}
{"n":1}
{"n":2}
```

The JSON export writes JSON lines by default, standardized as [Newline-delimited JSON](https://en.wikipedia.org/wiki/JSON_streaming#NDJSON).
The `ARRAY` option can be used to write a single JSON array object instead.

```sql
COPY (SELECT * FROM range(3) tbl(n)) TO 'output.json' (ARRAY);
```

```text
[
        {"n":0},
        {"n":1},
        {"n":2}
]
```

For additional options, see the [`COPY` statement documentation]({% link docs/1.2/sql/statements/copy.md %}).