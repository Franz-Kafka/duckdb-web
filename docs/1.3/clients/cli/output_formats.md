---
layout: docu
title: Output Formats
---

The `.mode` [dot command]({% link docs/1.3/clients/cli/dot_commands.md %}) may be used to change the appearance of the tables returned in the terminal output. In addition to customizing the appearance, these modes have additional benefits. This can be useful for presenting DuckDB output elsewhere by redirecting the terminal [output to a file]({% link docs/1.3/clients/cli/dot_commands.md %}#output-writing-results-to-a-file). Using the `insert` mode will build a series of SQL statements that can be used to insert the data at a later point.
The `markdown` mode is particularly useful for building documentation and the `latex` mode is useful for writing academic papers.

## List of Output Formats

<!-- markdownlint-disable MD056 -->

| Mode                                        | Description                                                    |
| ------------------------------------------- | -------------------------------------------------------------- |
| `ascii`                                     | Columns/rows delimited by 0x1F and 0x1E                        |
| `box`                                       | Tables using unicode box-drawing characters                    |
| `csv`                                       | Comma-separated values                                         |
| `column`                                    | Output in columns (See `.width`)                               |
| `duckbox`                                   | Tables with extensive features (default)                       |
| `html`                                      | HTML `<table>` code                                            |
| `insert ⟨TABLE⟩`{:.language-sql .highlight} | SQL insert statements for `⟨TABLE⟩`{:.language-sql .highlight} |
| `json`                                      | Results in a JSON array                                        |
| `jsonlines`                                 | Results in a NDJSON                                            |
| `latex`                                     | LaTeX tabular environment code                                 |
| `line`                                      | One value per line                                             |
| `list`                                      | Values delimited by `|`                                        |
| `markdown`                                  | Markdown table format                                          |
| `quote`                                     | Escape answers as for SQL                                      |
| `table`                                     | ASCII-art table                                                |
| `tabs`                                      | Tab-separated values                                           |
| `tcl`                                       | TCL list elements                                              |
| `trash`                                     | No output                                                      |

<!-- markdownlint-enable MD056 -->

## Changing the Output Format

Use the vanilla `.mode` dot command to query the appearance currently in use.

```sql
.mode
```

```text
current output mode: duckbox
```

Use the `.mode` dot command with an argument to set the output format.

```sql
.mode markdown
SELECT 'quacking intensifies' AS incoming_ducks;
```

```text
|    incoming_ducks    |
|----------------------|
| quacking intensifies |
```

The output appearance can also be adjusted with the `.separator` command. If using an export mode that relies on a separator (`csv` or `tabs` for example), the separator will be reset when the mode is changed. For example, `.mode csv` will set the separator to a comma (`,`). Using `.separator "|"` will then convert the output to be pipe-separated.

```sql
.mode csv
SELECT 1 AS col_1, 2 AS col_2
UNION ALL
SELECT 10 AS col1, 20 AS col_2;
```

```csv
col_1,col_2
1,2
10,20
```

```sql
.separator "|"
SELECT 1 AS col_1, 2 AS col_2
UNION ALL
SELECT 10 AS col1, 20 AS col_2;
```

```csv
col_1|col_2
1|2
10|20
```

## `duckbox` Mode

By default, DuckDB renders query results in `duckbox` mode, which is a feature-rich ASCII-art style output format.

The duckbox mode supports the `large_number_rendering` option, which allows human-readable rendering of large numbers. It has three levels:

- `off` – All numbers are printed using regular formatting.
- `footer` (default) – Large numbers are augmented with the human-readable format. Only applies to single-row results.
- `all` - All large numbers are replaced with the human-readable format.

See the following examples:

```sql
.large_number_rendering off
SELECT pi() * 1_000_000_000 AS x;
```

```text
┌───────────────────┐
│         x         │
│      double       │
├───────────────────┤
│ 3141592653.589793 │
└───────────────────┘
```

```sql
.large_number_rendering footer
SELECT pi() * 1_000_000_000 AS x;
```

```text
┌───────────────────┐
│         x         │
│      double       │
├───────────────────┤
│ 3141592653.589793 │
│  (3.14 billion)   │
└───────────────────┘
```

```sql
.large_number_rendering all
SELECT pi() * 1_000_000_000 AS x;
```

```text
┌──────────────┐
│      x       │
│    double    │
├──────────────┤
│ 3.14 billion │
└──────────────┘
```
