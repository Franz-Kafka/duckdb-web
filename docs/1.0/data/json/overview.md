---
layout: docu
redirect_from:
- /docs/archive/1.0/data/json
title: JSON Loading
---

## Examples

Read a JSON file from disk, auto-infer options:

```sql
SELECT * FROM 'todos.json';
```

Use the `read_json` function with custom options:

```sql
SELECT *
FROM read_json('todos.json',
               format = 'array',
               columns = {userId: 'UBIGINT',
                          id: 'UBIGINT',
                          title: 'VARCHAR',
                          completed: 'BOOLEAN'});
```

Read a JSON file from stdin, auto-infer options:

```batch
cat data/json/todos.json | duckdb -c "SELECT * FROM read_json('/dev/stdin')"
```

Read a JSON file into a table:

```sql
CREATE TABLE todos (userId UBIGINT, id UBIGINT, title VARCHAR, completed BOOLEAN);
COPY todos FROM 'todos.json';
```

Alternatively, create a table without specifying the schema manually with a [`CREATE TABLE ... AS SELECT` clause]({% link docs/1.0/sql/statements/create_table.md %}#create-table--as-select-ctas):

```sql
CREATE TABLE todos AS
    SELECT * FROM 'todos.json';
```

Write the result of a query to a JSON file:

```sql
COPY (SELECT * FROM todos) TO 'todos.json';
```

## JSON Loading

JSON is an open standard file format and data interchange format that uses human-readable text to store and transmit data objects consisting of attribute–value pairs and arrays (or other serializable values).
While it is not a very efficient format for tabular data, it is very commonly used, especially as a data interchange format.

The DuckDB JSON reader can automatically infer which configuration flags to use by analyzing the JSON file. This will work correctly in most situations, and should be the first option attempted. In rare situations where the JSON reader cannot figure out the correct configuration, it is possible to manually configure the JSON reader to correctly parse the JSON file.

Below are parameters that can be passed in to the JSON reader.

## Parameters

| Name | Description | Type | Default |
|:--|:-----|:-|:-|
| `auto_detect` | Whether to auto-detect detect the names of the keys and data types of the values automatically | `BOOL` | `false` |
| `columns` | A struct that specifies the key names and value types contained within the JSON file (e.g., `{key1: 'INTEGER', key2: 'VARCHAR'}`). If `auto_detect` is enabled these will be inferred | `STRUCT` | `(empty)` |
| `compression` | The compression type for the file. By default this will be detected automatically from the file extension (e.g., `t.json.gz` will use gzip, `t.json` will use none). Options are `'uncompressed'`, `'gzip'`, `'zstd'`, and `'auto_detect'`. | `VARCHAR` | `'auto_detect'` |
| `convert_strings_to_integers` | Whether strings representing integer values should be converted to a numerical type. | `BOOL` | `false` |
| `dateformat` | Specifies the date format to use when parsing dates. See [Date Format]({% link docs/1.0/sql/functions/dateformat.md %}) | `VARCHAR` | `'iso'` |
| `filename` | Whether or not an extra `filename` column should be included in the result. | `BOOL` | `false` |
| `format` | Can be one of `['auto', 'unstructured', 'newline_delimited', 'array']` | `VARCHAR` | `'array'` |
| `hive_partitioning` | Whether or not to interpret the path as a [Hive partitioned path]({% link docs/1.0/data/partitioning/hive_partitioning.md %}). | `BOOL` | `false` |
| `ignore_errors` | Whether to ignore parse errors (only possible when `format` is `'newline_delimited'`) | `BOOL` | `false` |
| `maximum_depth` | Maximum nesting depth to which the automatic schema detection detects types. Set to -1 to fully detect nested JSON types | `BIGINT` | `-1` |
| `maximum_object_size` | The maximum size of a JSON object (in bytes) | `UINTEGER` | `16777216` |
| `records` | Can be one of `['auto', 'true', 'false']` | `VARCHAR` | `'records'` |
| `sample_size` | Option to define number of sample objects for automatic JSON type detection. Set to -1 to scan the entire input file | `UBIGINT` | `20480` |
| `timestampformat` | Specifies the date format to use when parsing timestamps. See [Date Format]({% link docs/1.0/sql/functions/dateformat.md %}) | `VARCHAR` | `'iso'`|
| `union_by_name` | Whether the schema's of multiple JSON files should be [unified]({% link docs/1.0/data/multiple_files/combining_schemas.md %}). | `BOOL` | `false` |

## Examples of Format Settings

The JSON extension can attempt to determine the format of a JSON file when setting `format` to `auto`.
Here are some example JSON files and the corresponding `format` settings that should be used.

In each of the below cases, the `format` setting was not needed, as DuckDB was able to infer it correctly, but it is included for illustrative purposes.
A query of this shape would work in each case:

```sql
SELECT *
FROM filename.json;
```

### Format: `newline_delimited`

With `format = 'newline_delimited'` newline-delimited JSON can be parsed.
Each line is a JSON.

We use the example file [`records.json`](/data/records.json) with the following content:

```json
{"key1":"value1", "key2": "value1"}
{"key1":"value2", "key2": "value2"}
{"key1":"value3", "key2": "value3"}
```

```sql
SELECT *
FROM read_json('records.json', format = 'newline_delimited');
```

<div class="monospace_table"></div>

|  key1  |  key2  |
|--------|--------|
| value1 | value1 |
| value2 | value2 |
| value3 | value3 |

### Format: `array`

If the JSON file contains a JSON array of objects (pretty-printed or not), `array_of_objects` may be used.
To demonstrate its use, we use the example file [`records-in-array.json`](/data/records-in-array.json):

```json
[
    {"key1":"value1", "key2": "value1"},
    {"key1":"value2", "key2": "value2"},
    {"key1":"value3", "key2": "value3"}
]
```

```sql
SELECT *
FROM read_json('records-in-array.json', format = 'array');
```

<div class="monospace_table"></div>

|  key1  |  key2  |
|--------|--------|
| value1 | value1 |
| value2 | value2 |
| value3 | value3 |

### Format: `unstructured`

If the JSON file contains JSON that is not newline-delimited or an array, `unstructured` may be used.
To demonstrate its use, we use the example file [`unstructured.json`](/data/unstructured.json):

```json
{
    "key1":"value1",
    "key2":"value1"
}
{
    "key1":"value2",
    "key2":"value2"
}
{
    "key1":"value3",
    "key2":"value3"
}
```

```sql
SELECT *
FROM read_json('unstructured.json', format = 'unstructured');
```

<div class="monospace_table"></div>

|  key1  |  key2  |
|--------|--------|
| value1 | value1 |
| value2 | value2 |
| value3 | value3 |

## Examples of Records Settings

The JSON extension can attempt to determine whether a JSON file contains records when setting `records = auto`.
When `records = true`, the JSON extension expects JSON objects, and will unpack the fields of JSON objects into individual columns.

Continuing with the same example file, [`records.json`](/data/records.json):

```json
{"key1":"value1", "key2": "value1"}
{"key1":"value2", "key2": "value2"}
{"key1":"value3", "key2": "value3"}
```

```sql
SELECT *
FROM read_json('records.json', records = true);
```

<div class="monospace_table"></div>

|  key1  |  key2  |
|--------|--------|
| value1 | value1 |
| value2 | value2 |
| value3 | value3 |

When `records = false`, the JSON extension will not unpack the top-level objects, and create `STRUCT`s instead:

```sql
SELECT *
FROM read_json('records.json', records = false);
```

<div class="monospace_table"></div>

|               json               |
|----------------------------------|
| {'key1': value1, 'key2': value1} |
| {'key1': value2, 'key2': value2} |
| {'key1': value3, 'key2': value3} |

This is especially useful if we have non-object JSON, for example, [`arrays.json`](/data/arrays.json):

```json
[1, 2, 3]
[4, 5, 6]
[7, 8, 9]
```

```sql
SELECT *
FROM read_json('arrays.json', records = false);
```

<div class="monospace_table"></div>

|   json    |
|-----------|
| [1, 2, 3] |
| [4, 5, 6] |
| [7, 8, 9] |

## Writing

The contents of tables or the result of queries can be written directly to a JSON file using the `COPY` statement. See the [COPY documentation]({% link docs/1.0/sql/statements/copy.md %}#copy-to) for more information.

## `read_json` Function

The `read_json` is the simplest method of loading JSON files: it automatically attempts to figure out the correct configuration of the JSON reader. It also automatically deduces types of columns.

```sql
SELECT *
FROM read_json('todos.json')
LIMIT 5;
```

<div class="monospace_table"></div>

| userId | id |                              title                              | completed |
|-------:|---:|-----------------------------------------------------------------|-----------|
| 1      | 1  | delectus aut autem                                              | false     |
| 1      | 2  | quis ut nam facilis et officia qui                              | false     |
| 1      | 3  | fugiat veniam minus                                             | false     |
| 1      | 4  | et porro tempora                                                | true      |
| 1      | 5  | laboriosam mollitia et enim quasi adipisci quia provident illum | false     |

The path can either be a relative path (relative to the current working directory) or an absolute path.

We can use `read_json` to create a persistent table as well:

```sql
CREATE TABLE todos AS
    SELECT *
    FROM read_json('todos.json');
DESCRIBE todos;
```

<div class="monospace_table"></div>

| column_name | column_type | null | key | default | extra |
|-------------|-------------|------|-----|---------|-------|
| userId      | UBIGINT     | YES  |     |         |       |
| id          | UBIGINT     | YES  |     |         |       |
| title       | VARCHAR     | YES  |     |         |       |
| completed   | BOOLEAN     | YES  |     |         |       |

If we specify the columns, we can bypass the automatic detection. Note that not all columns need to be specified:

```sql
SELECT *
FROM read_json('todos.json',
                    columns = {userId: 'UBIGINT',
                               completed: 'BOOLEAN'});
```

Multiple files can be read at once by providing a glob or a list of files. Refer to the [multiple files section]({% link docs/1.0/data/multiple_files/overview.md %}) for more information.

## `COPY` Statement

The `COPY` statement can be used to load data from a JSON file into a table. For the `COPY` statement, we must first create a table with the correct schema to load the data into. We then specify the JSON file to load from plus any configuration options separately.

```sql
CREATE TABLE todos (userId UBIGINT, id UBIGINT, title VARCHAR, completed BOOLEAN);
COPY todos FROM 'todos.json';
SELECT * FROM todos LIMIT 5;
```

<div class="monospace_table"></div>

| userId | id |                              title                              | completed |
|--------|----|-----------------------------------------------------------------|-----------|
| 1      | 1  | delectus aut autem                                              | false     |
| 1      | 2  | quis ut nam facilis et officia qui                              | false     |
| 1      | 3  | fugiat veniam minus                                             | false     |
| 1      | 4  | et porro tempora                                                | true      |
| 1      | 5  | laboriosam mollitia et enim quasi adipisci quia provident illum | false     |

For more details, see the [page on the `COPY` statement]({% link docs/1.0/sql/statements/copy.md %}).

<!-- ## Pages in This Section -->