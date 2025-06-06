---
layout: docu
title: Appender
---

<!-- markdownlint-disable MD001 -->

Appenders are the most efficient way of loading data into DuckDB from within the C interface, and are recommended for
fast data loading. The appender is much faster than using prepared statements or individual `INSERT INTO` statements.

Appends are made in row-wise format. For every column, a `duckdb_append_[type]` call should be made, after which
the row should be finished by calling `duckdb_appender_end_row`. After all rows have been appended,
`duckdb_appender_destroy` should be used to finalize the appender and clean up the resulting memory.

Note that `duckdb_appender_destroy` should always be called on the resulting appender, even if the function returns
`DuckDBError`.

## Example

```c
duckdb_query(con, "CREATE TABLE people (id INTEGER, name VARCHAR)", NULL);

duckdb_appender appender;
if (duckdb_appender_create(con, NULL, "people", &appender) == DuckDBError) {
  // handle error
}
// append the first row (1, Mark)
duckdb_append_int32(appender, 1);
duckdb_append_varchar(appender, "Mark");
duckdb_appender_end_row(appender);

// append the second row (2, Hannes)
duckdb_append_int32(appender, 2);
duckdb_append_varchar(appender, "Hannes");
duckdb_appender_end_row(appender);

// finish appending and flush all the rows to the table
duckdb_appender_destroy(&appender);
```

## API Reference Overview

<!-- This section is generated by scripts/generate_c_api_docs.py -->

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <a href="#duckdb_appender_create"><span class="nf">duckdb_appender_create</span></a>(<span class="kt">duckdb_connection</span> <span class="nv">connection</span>, <span class="kt">const</span> <span class="kt">char</span> *<span class="nv">schema</span>, <span class="kt">const</span> <span class="kt">char</span> *<span class="nv">table</span>, <span class="kt">duckdb_appender</span> *<span class="nv">out_appender</span>);
<span class="kt">duckdb_state</span> <a href="#duckdb_appender_create_ext"><span class="nf">duckdb_appender_create_ext</span></a>(<span class="kt">duckdb_connection</span> <span class="nv">connection</span>, <span class="kt">const</span> <span class="kt">char</span> *<span class="nv">catalog</span>, <span class="kt">const</span> <span class="kt">char</span> *<span class="nv">schema</span>, <span class="kt">const</span> <span class="kt">char</span> *<span class="nv">table</span>, <span class="kt">duckdb_appender</span> *<span class="nv">out_appender</span>);
<span class="kt">idx_t</span> <a href="#duckdb_appender_column_count"><span class="nf">duckdb_appender_column_count</span></a>(<span class="kt">duckdb_appender</span> <span class="nv">appender</span>);
<span class="kt">duckdb_logical_type</span> <a href="#duckdb_appender_column_type"><span class="nf">duckdb_appender_column_type</span></a>(<span class="kt">duckdb_appender</span> <span class="nv">appender</span>, <span class="kt">idx_t</span> <span class="nv">col_idx</span>);
<span class="kt">const</span> <span class="kt">char</span> *<a href="#duckdb_appender_error"><span class="nf">duckdb_appender_error</span></a>(<span class="kt">duckdb_appender</span> <span class="nv">appender</span>);
<span class="kt">duckdb_state</span> <a href="#duckdb_appender_flush"><span class="nf">duckdb_appender_flush</span></a>(<span class="kt">duckdb_appender</span> <span class="nv">appender</span>);
<span class="kt">duckdb_state</span> <a href="#duckdb_appender_close"><span class="nf">duckdb_appender_close</span></a>(<span class="kt">duckdb_appender</span> <span class="nv">appender</span>);
<span class="kt">duckdb_state</span> <a href="#duckdb_appender_destroy"><span class="nf">duckdb_appender_destroy</span></a>(<span class="kt">duckdb_appender</span> *<span class="nv">appender</span>);
<span class="kt">duckdb_state</span> <a href="#duckdb_appender_add_column"><span class="nf">duckdb_appender_add_column</span></a>(<span class="kt">duckdb_appender</span> <span class="nv">appender</span>, <span class="kt">const</span> <span class="kt">char</span> *<span class="nv">name</span>);
<span class="kt">duckdb_state</span> <a href="#duckdb_appender_clear_columns"><span class="nf">duckdb_appender_clear_columns</span></a>(<span class="kt">duckdb_appender</span> <span class="nv">appender</span>);
<span class="kt">duckdb_state</span> <a href="#duckdb_appender_begin_row"><span class="nf">duckdb_appender_begin_row</span></a>(<span class="kt">duckdb_appender</span> <span class="nv">appender</span>);
<span class="kt">duckdb_state</span> <a href="#duckdb_appender_end_row"><span class="nf">duckdb_appender_end_row</span></a>(<span class="kt">duckdb_appender</span> <span class="nv">appender</span>);
<span class="kt">duckdb_state</span> <a href="#duckdb_append_default"><span class="nf">duckdb_append_default</span></a>(<span class="kt">duckdb_appender</span> <span class="nv">appender</span>);
<span class="kt">duckdb_state</span> <a href="#duckdb_append_default_to_chunk"><span class="nf">duckdb_append_default_to_chunk</span></a>(<span class="kt">duckdb_appender</span> <span class="nv">appender</span>, <span class="kt">duckdb_data_chunk</span> <span class="nv">chunk</span>, <span class="kt">idx_t</span> <span class="nv">col</span>, <span class="kt">idx_t</span> <span class="nv">row</span>);
<span class="kt">duckdb_state</span> <a href="#duckdb_append_bool"><span class="nf">duckdb_append_bool</span></a>(<span class="kt">duckdb_appender</span> <span class="nv">appender</span>, <span class="kt">bool</span> <span class="nv">value</span>);
<span class="kt">duckdb_state</span> <a href="#duckdb_append_int8"><span class="nf">duckdb_append_int8</span></a>(<span class="kt">duckdb_appender</span> <span class="nv">appender</span>, <span class="kt">int8_t</span> <span class="nv">value</span>);
<span class="kt">duckdb_state</span> <a href="#duckdb_append_int16"><span class="nf">duckdb_append_int16</span></a>(<span class="kt">duckdb_appender</span> <span class="nv">appender</span>, <span class="kt">int16_t</span> <span class="nv">value</span>);
<span class="kt">duckdb_state</span> <a href="#duckdb_append_int32"><span class="nf">duckdb_append_int32</span></a>(<span class="kt">duckdb_appender</span> <span class="nv">appender</span>, <span class="kt">int32_t</span> <span class="nv">value</span>);
<span class="kt">duckdb_state</span> <a href="#duckdb_append_int64"><span class="nf">duckdb_append_int64</span></a>(<span class="kt">duckdb_appender</span> <span class="nv">appender</span>, <span class="kt">int64_t</span> <span class="nv">value</span>);
<span class="kt">duckdb_state</span> <a href="#duckdb_append_hugeint"><span class="nf">duckdb_append_hugeint</span></a>(<span class="kt">duckdb_appender</span> <span class="nv">appender</span>, <span class="kt">duckdb_hugeint</span> <span class="nv">value</span>);
<span class="kt">duckdb_state</span> <a href="#duckdb_append_uint8"><span class="nf">duckdb_append_uint8</span></a>(<span class="kt">duckdb_appender</span> <span class="nv">appender</span>, <span class="kt">uint8_t</span> <span class="nv">value</span>);
<span class="kt">duckdb_state</span> <a href="#duckdb_append_uint16"><span class="nf">duckdb_append_uint16</span></a>(<span class="kt">duckdb_appender</span> <span class="nv">appender</span>, <span class="kt">uint16_t</span> <span class="nv">value</span>);
<span class="kt">duckdb_state</span> <a href="#duckdb_append_uint32"><span class="nf">duckdb_append_uint32</span></a>(<span class="kt">duckdb_appender</span> <span class="nv">appender</span>, <span class="kt">uint32_t</span> <span class="nv">value</span>);
<span class="kt">duckdb_state</span> <a href="#duckdb_append_uint64"><span class="nf">duckdb_append_uint64</span></a>(<span class="kt">duckdb_appender</span> <span class="nv">appender</span>, <span class="kt">uint64_t</span> <span class="nv">value</span>);
<span class="kt">duckdb_state</span> <a href="#duckdb_append_uhugeint"><span class="nf">duckdb_append_uhugeint</span></a>(<span class="kt">duckdb_appender</span> <span class="nv">appender</span>, <span class="kt">duckdb_uhugeint</span> <span class="nv">value</span>);
<span class="kt">duckdb_state</span> <a href="#duckdb_append_float"><span class="nf">duckdb_append_float</span></a>(<span class="kt">duckdb_appender</span> <span class="nv">appender</span>, <span class="kt">float</span> <span class="nv">value</span>);
<span class="kt">duckdb_state</span> <a href="#duckdb_append_double"><span class="nf">duckdb_append_double</span></a>(<span class="kt">duckdb_appender</span> <span class="nv">appender</span>, <span class="kt">double</span> <span class="nv">value</span>);
<span class="kt">duckdb_state</span> <a href="#duckdb_append_date"><span class="nf">duckdb_append_date</span></a>(<span class="kt">duckdb_appender</span> <span class="nv">appender</span>, <span class="kt">duckdb_date</span> <span class="nv">value</span>);
<span class="kt">duckdb_state</span> <a href="#duckdb_append_time"><span class="nf">duckdb_append_time</span></a>(<span class="kt">duckdb_appender</span> <span class="nv">appender</span>, <span class="kt">duckdb_time</span> <span class="nv">value</span>);
<span class="kt">duckdb_state</span> <a href="#duckdb_append_timestamp"><span class="nf">duckdb_append_timestamp</span></a>(<span class="kt">duckdb_appender</span> <span class="nv">appender</span>, <span class="kt">duckdb_timestamp</span> <span class="nv">value</span>);
<span class="kt">duckdb_state</span> <a href="#duckdb_append_interval"><span class="nf">duckdb_append_interval</span></a>(<span class="kt">duckdb_appender</span> <span class="nv">appender</span>, <span class="kt">duckdb_interval</span> <span class="nv">value</span>);
<span class="kt">duckdb_state</span> <a href="#duckdb_append_varchar"><span class="nf">duckdb_append_varchar</span></a>(<span class="kt">duckdb_appender</span> <span class="nv">appender</span>, <span class="kt">const</span> <span class="kt">char</span> *<span class="nv">val</span>);
<span class="kt">duckdb_state</span> <a href="#duckdb_append_varchar_length"><span class="nf">duckdb_append_varchar_length</span></a>(<span class="kt">duckdb_appender</span> <span class="nv">appender</span>, <span class="kt">const</span> <span class="kt">char</span> *<span class="nv">val</span>, <span class="kt">idx_t</span> <span class="nv">length</span>);
<span class="kt">duckdb_state</span> <a href="#duckdb_append_blob"><span class="nf">duckdb_append_blob</span></a>(<span class="kt">duckdb_appender</span> <span class="nv">appender</span>, <span class="kt">const</span> <span class="kt">void</span> *<span class="nv">data</span>, <span class="kt">idx_t</span> <span class="nv">length</span>);
<span class="kt">duckdb_state</span> <a href="#duckdb_append_null"><span class="nf">duckdb_append_null</span></a>(<span class="kt">duckdb_appender</span> <span class="nv">appender</span>);
<span class="kt">duckdb_state</span> <a href="#duckdb_append_value"><span class="nf">duckdb_append_value</span></a>(<span class="kt">duckdb_appender</span> <span class="nv">appender</span>, <span class="kt">duckdb_value</span> <span class="nv">value</span>);
<span class="kt">duckdb_state</span> <a href="#duckdb_append_data_chunk"><span class="nf">duckdb_append_data_chunk</span></a>(<span class="kt">duckdb_appender</span> <span class="nv">appender</span>, <span class="kt">duckdb_data_chunk</span> <span class="nv">chunk</span>);
</code></pre></div></div>

#### `duckdb_appender_create`

Creates an appender object.

Note that the object must be destroyed with `duckdb_appender_destroy`.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <span class="nv">duckdb_appender_create</span>(<span class="nv">
</span>  <span class="kt">duckdb_connection</span> <span class="nv">connection</span>,<span class="nv">
</span>  <span class="kt">const</span> <span class="kt">char</span> *<span class="nv">schema</span>,<span class="nv">
</span>  <span class="kt">const</span> <span class="kt">char</span> *<span class="nv">table</span>,<span class="nv">
</span>  <span class="kt">duckdb_appender</span> *<span class="nv">out_appender
</span>);
</code></pre></div></div>

##### Parameters

* `connection`: The connection context to create the appender in.
* `schema`: The schema of the table to append to, or `nullptr` for the default schema.
* `table`: The table name to append to.
* `out_appender`: The resulting appender object.

##### Return Value

`DuckDBSuccess` on success or `DuckDBError` on failure.

<br>

#### `duckdb_appender_create_ext`

Creates an appender object.

Note that the object must be destroyed with `duckdb_appender_destroy`.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <span class="nv">duckdb_appender_create_ext</span>(<span class="nv">
</span>  <span class="kt">duckdb_connection</span> <span class="nv">connection</span>,<span class="nv">
</span>  <span class="kt">const</span> <span class="kt">char</span> *<span class="nv">catalog</span>,<span class="nv">
</span>  <span class="kt">const</span> <span class="kt">char</span> *<span class="nv">schema</span>,<span class="nv">
</span>  <span class="kt">const</span> <span class="kt">char</span> *<span class="nv">table</span>,<span class="nv">
</span>  <span class="kt">duckdb_appender</span> *<span class="nv">out_appender
</span>);
</code></pre></div></div>

##### Parameters

* `connection`: The connection context to create the appender in.
* `catalog`: The catalog of the table to append to, or `nullptr` for the default catalog.
* `schema`: The schema of the table to append to, or `nullptr` for the default schema.
* `table`: The table name to append to.
* `out_appender`: The resulting appender object.

##### Return Value

`DuckDBSuccess` on success or `DuckDBError` on failure.

<br>

#### `duckdb_appender_column_count`

Returns the number of columns that belong to the appender.
If there is no active column list, then this equals the table's physical columns.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">idx_t</span> <span class="nv">duckdb_appender_column_count</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> <span class="nv">appender
</span>);
</code></pre></div></div>

##### Parameters

* `appender`: The appender to get the column count from.

##### Return Value

The number of columns in the data chunks.

<br>

#### `duckdb_appender_column_type`

Returns the type of the column at the specified index. This is either a type in the active column list, or the same type
as a column in the receiving table.

Note: The resulting type must be destroyed with `duckdb_destroy_logical_type`.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_logical_type</span> <span class="nv">duckdb_appender_column_type</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> <span class="nv">appender</span>,<span class="nv">
</span>  <span class="kt">idx_t</span> <span class="nv">col_idx
</span>);
</code></pre></div></div>

##### Parameters

* `appender`: The appender to get the column type from.
* `col_idx`: The index of the column to get the type of.

##### Return Value

The `duckdb_logical_type` of the column.

<br>

#### `duckdb_appender_error`

Returns the error message associated with the given appender.
If the appender has no error message, this returns `nullptr` instead.

The error message should not be freed. It will be de-allocated when `duckdb_appender_destroy` is called.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">const</span> <span class="kt">char</span> *<span class="nv">duckdb_appender_error</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> <span class="nv">appender
</span>);
</code></pre></div></div>

##### Parameters

* `appender`: The appender to get the error from.

##### Return Value

The error message, or `nullptr` if there is none.

<br>

#### `duckdb_appender_flush`

Flush the appender to the table, forcing the cache of the appender to be cleared. If flushing the data triggers a
constraint violation or any other error, then all data is invalidated, and this function returns DuckDBError.
It is not possible to append more values. Call duckdb_appender_error to obtain the error message followed by
duckdb_appender_destroy to destroy the invalidated appender.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <span class="nv">duckdb_appender_flush</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> <span class="nv">appender
</span>);
</code></pre></div></div>

##### Parameters

* `appender`: The appender to flush.

##### Return Value

`DuckDBSuccess` on success or `DuckDBError` on failure.

<br>

#### `duckdb_appender_close`

Closes the appender by flushing all intermediate states and closing it for further appends. If flushing the data
triggers a constraint violation or any other error, then all data is invalidated, and this function returns DuckDBError.
Call duckdb_appender_error to obtain the error message followed by duckdb_appender_destroy to destroy the invalidated
appender.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <span class="nv">duckdb_appender_close</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> <span class="nv">appender
</span>);
</code></pre></div></div>

##### Parameters

* `appender`: The appender to flush and close.

##### Return Value

`DuckDBSuccess` on success or `DuckDBError` on failure.

<br>

#### `duckdb_appender_destroy`

Closes the appender by flushing all intermediate states to the table and destroying it. By destroying it, this function
de-allocates all memory associated with the appender. If flushing the data triggers a constraint violation,
then all data is invalidated, and this function returns DuckDBError. Due to the destruction of the appender, it is no
longer possible to obtain the specific error message with duckdb_appender_error. Therefore, call duckdb_appender_close
before destroying the appender, if you need insights into the specific error.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <span class="nv">duckdb_appender_destroy</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> *<span class="nv">appender
</span>);
</code></pre></div></div>

##### Parameters

* `appender`: The appender to flush, close and destroy.

##### Return Value

`DuckDBSuccess` on success or `DuckDBError` on failure.

<br>

#### `duckdb_appender_add_column`

Appends a column to the active column list of the appender. Immediately flushes all previous data.

The active column list specifies all columns that are expected when flushing the data. Any non-active columns are filled
with their default values, or NULL.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <span class="nv">duckdb_appender_add_column</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> <span class="nv">appender</span>,<span class="nv">
</span>  <span class="kt">const</span> <span class="kt">char</span> *<span class="nv">name
</span>);
</code></pre></div></div>

##### Parameters

* `appender`: The appender to add the column to.

##### Return Value

`DuckDBSuccess` on success or `DuckDBError` on failure.

<br>

#### `duckdb_appender_clear_columns`

Removes all columns from the active column list of the appender, resetting the appender to treat all columns as active.
Immediately flushes all previous data.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <span class="nv">duckdb_appender_clear_columns</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> <span class="nv">appender
</span>);
</code></pre></div></div>

##### Parameters

* `appender`: The appender to clear the columns from.

##### Return Value

`DuckDBSuccess` on success or `DuckDBError` on failure.

<br>

#### `duckdb_appender_begin_row`

A nop function, provided for backwards compatibility reasons. Does nothing. Only `duckdb_appender_end_row` is required.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <span class="nv">duckdb_appender_begin_row</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> <span class="nv">appender
</span>);
</code></pre></div></div>
<br>

#### `duckdb_appender_end_row`

Finish the current row of appends. After end_row is called, the next row can be appended.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <span class="nv">duckdb_appender_end_row</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> <span class="nv">appender
</span>);
</code></pre></div></div>

##### Parameters

* `appender`: The appender.

##### Return Value

`DuckDBSuccess` on success or `DuckDBError` on failure.

<br>

#### `duckdb_append_default`

Append a DEFAULT value (NULL if DEFAULT not available for column) to the appender.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <span class="nv">duckdb_append_default</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> <span class="nv">appender
</span>);
</code></pre></div></div>
<br>

#### `duckdb_append_default_to_chunk`

Append a DEFAULT value, at the specified row and column, (NULL if DEFAULT not available for column) to the chunk created
from the specified appender. The default value of the column must be a constant value. Non-deterministic expressions
like nextval('seq') or random() are not supported.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <span class="nv">duckdb_append_default_to_chunk</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> <span class="nv">appender</span>,<span class="nv">
</span>  <span class="kt">duckdb_data_chunk</span> <span class="nv">chunk</span>,<span class="nv">
</span>  <span class="kt">idx_t</span> <span class="nv">col</span>,<span class="nv">
</span>  <span class="kt">idx_t</span> <span class="nv">row
</span>);
</code></pre></div></div>

##### Parameters

* `appender`: The appender to get the default value from.
* `chunk`: The data chunk to append the default value to.
* `col`: The chunk column index to append the default value to.
* `row`: The chunk row index to append the default value to.

##### Return Value

`DuckDBSuccess` on success or `DuckDBError` on failure.

<br>

#### `duckdb_append_bool`

Append a bool value to the appender.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <span class="nv">duckdb_append_bool</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> <span class="nv">appender</span>,<span class="nv">
</span>  <span class="kt">bool</span> <span class="nv">value
</span>);
</code></pre></div></div>
<br>

#### `duckdb_append_int8`

Append an int8_t value to the appender.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <span class="nv">duckdb_append_int8</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> <span class="nv">appender</span>,<span class="nv">
</span>  <span class="kt">int8_t</span> <span class="nv">value
</span>);
</code></pre></div></div>
<br>

#### `duckdb_append_int16`

Append an int16_t value to the appender.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <span class="nv">duckdb_append_int16</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> <span class="nv">appender</span>,<span class="nv">
</span>  <span class="kt">int16_t</span> <span class="nv">value
</span>);
</code></pre></div></div>
<br>

#### `duckdb_append_int32`

Append an int32_t value to the appender.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <span class="nv">duckdb_append_int32</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> <span class="nv">appender</span>,<span class="nv">
</span>  <span class="kt">int32_t</span> <span class="nv">value
</span>);
</code></pre></div></div>
<br>

#### `duckdb_append_int64`

Append an int64_t value to the appender.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <span class="nv">duckdb_append_int64</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> <span class="nv">appender</span>,<span class="nv">
</span>  <span class="kt">int64_t</span> <span class="nv">value
</span>);
</code></pre></div></div>
<br>

#### `duckdb_append_hugeint`

Append a duckdb_hugeint value to the appender.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <span class="nv">duckdb_append_hugeint</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> <span class="nv">appender</span>,<span class="nv">
</span>  <span class="kt">duckdb_hugeint</span> <span class="nv">value
</span>);
</code></pre></div></div>
<br>

#### `duckdb_append_uint8`

Append a uint8_t value to the appender.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <span class="nv">duckdb_append_uint8</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> <span class="nv">appender</span>,<span class="nv">
</span>  <span class="kt">uint8_t</span> <span class="nv">value
</span>);
</code></pre></div></div>
<br>

#### `duckdb_append_uint16`

Append a uint16_t value to the appender.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <span class="nv">duckdb_append_uint16</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> <span class="nv">appender</span>,<span class="nv">
</span>  <span class="kt">uint16_t</span> <span class="nv">value
</span>);
</code></pre></div></div>
<br>

#### `duckdb_append_uint32`

Append a uint32_t value to the appender.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <span class="nv">duckdb_append_uint32</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> <span class="nv">appender</span>,<span class="nv">
</span>  <span class="kt">uint32_t</span> <span class="nv">value
</span>);
</code></pre></div></div>
<br>

#### `duckdb_append_uint64`

Append a uint64_t value to the appender.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <span class="nv">duckdb_append_uint64</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> <span class="nv">appender</span>,<span class="nv">
</span>  <span class="kt">uint64_t</span> <span class="nv">value
</span>);
</code></pre></div></div>
<br>

#### `duckdb_append_uhugeint`

Append a duckdb_uhugeint value to the appender.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <span class="nv">duckdb_append_uhugeint</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> <span class="nv">appender</span>,<span class="nv">
</span>  <span class="kt">duckdb_uhugeint</span> <span class="nv">value
</span>);
</code></pre></div></div>
<br>

#### `duckdb_append_float`

Append a float value to the appender.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <span class="nv">duckdb_append_float</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> <span class="nv">appender</span>,<span class="nv">
</span>  <span class="kt">float</span> <span class="nv">value
</span>);
</code></pre></div></div>
<br>

#### `duckdb_append_double`

Append a double value to the appender.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <span class="nv">duckdb_append_double</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> <span class="nv">appender</span>,<span class="nv">
</span>  <span class="kt">double</span> <span class="nv">value
</span>);
</code></pre></div></div>
<br>

#### `duckdb_append_date`

Append a duckdb_date value to the appender.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <span class="nv">duckdb_append_date</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> <span class="nv">appender</span>,<span class="nv">
</span>  <span class="kt">duckdb_date</span> <span class="nv">value
</span>);
</code></pre></div></div>
<br>

#### `duckdb_append_time`

Append a duckdb_time value to the appender.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <span class="nv">duckdb_append_time</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> <span class="nv">appender</span>,<span class="nv">
</span>  <span class="kt">duckdb_time</span> <span class="nv">value
</span>);
</code></pre></div></div>
<br>

#### `duckdb_append_timestamp`

Append a duckdb_timestamp value to the appender.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <span class="nv">duckdb_append_timestamp</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> <span class="nv">appender</span>,<span class="nv">
</span>  <span class="kt">duckdb_timestamp</span> <span class="nv">value
</span>);
</code></pre></div></div>
<br>

#### `duckdb_append_interval`

Append a duckdb_interval value to the appender.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <span class="nv">duckdb_append_interval</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> <span class="nv">appender</span>,<span class="nv">
</span>  <span class="kt">duckdb_interval</span> <span class="nv">value
</span>);
</code></pre></div></div>
<br>

#### `duckdb_append_varchar`

Append a varchar value to the appender.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <span class="nv">duckdb_append_varchar</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> <span class="nv">appender</span>,<span class="nv">
</span>  <span class="kt">const</span> <span class="kt">char</span> *<span class="nv">val
</span>);
</code></pre></div></div>
<br>

#### `duckdb_append_varchar_length`

Append a varchar value to the appender.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <span class="nv">duckdb_append_varchar_length</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> <span class="nv">appender</span>,<span class="nv">
</span>  <span class="kt">const</span> <span class="kt">char</span> *<span class="nv">val</span>,<span class="nv">
</span>  <span class="kt">idx_t</span> <span class="nv">length
</span>);
</code></pre></div></div>
<br>

#### `duckdb_append_blob`

Append a blob value to the appender.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <span class="nv">duckdb_append_blob</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> <span class="nv">appender</span>,<span class="nv">
</span>  <span class="kt">const</span> <span class="kt">void</span> *<span class="nv">data</span>,<span class="nv">
</span>  <span class="kt">idx_t</span> <span class="nv">length
</span>);
</code></pre></div></div>
<br>

#### `duckdb_append_null`

Append a NULL value to the appender (of any type).

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <span class="nv">duckdb_append_null</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> <span class="nv">appender
</span>);
</code></pre></div></div>
<br>

#### `duckdb_append_value`

Append a duckdb_value to the appender.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <span class="nv">duckdb_append_value</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> <span class="nv">appender</span>,<span class="nv">
</span>  <span class="kt">duckdb_value</span> <span class="nv">value
</span>);
</code></pre></div></div>
<br>

#### `duckdb_append_data_chunk`

Appends a pre-filled data chunk to the specified appender.
Attempts casting, if the data chunk types do not match the active appender types.

##### Syntax

<div class="language-c highlighter-rouge"><div class="highlight"><pre class="highlight"><code><span class="kt">duckdb_state</span> <span class="nv">duckdb_append_data_chunk</span>(<span class="nv">
</span>  <span class="kt">duckdb_appender</span> <span class="nv">appender</span>,<span class="nv">
</span>  <span class="kt">duckdb_data_chunk</span> <span class="nv">chunk
</span>);
</code></pre></div></div>

##### Parameters

* `appender`: The appender to append to.
* `chunk`: The data chunk to append.

##### Return Value

`DuckDBSuccess` on success or `DuckDBError` on failure.

<br>