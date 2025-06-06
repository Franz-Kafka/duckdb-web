---
github_repository: https://github.com/duckdb/duckdb-fts
layout: docu
title: Full-Text Search Extension
redirect_from:
- /docs/stable/extensions/full_text_search
- /docs/stable/extensions/full_text_search/
- /docs/extensions/full_text_search
- /docs/extensions/full_text_search/
---

Full-Text Search is an extension to DuckDB that allows for search through strings, similar to [SQLite's FTS5 extension](https://www.sqlite.org/fts5.html).

## Installing and Loading

The `fts` extension will be transparently [autoloaded]({% link docs/stable/core_extensions/overview.md %}#autoloading-extensions) on first use from the official extension repository.
If you would like to install and load it manually, run:

```sql
INSTALL fts;
LOAD fts;
```

## Usage

The extension adds two `PRAGMA` statements to DuckDB: one to create, and one to drop an index. Additionally, a scalar macro `stem` is added, which is used internally by the extension.

### `PRAGMA create_fts_index`

```python
create_fts_index(input_table, input_id, *input_values, stemmer = 'porter',
                 stopwords = 'english', ignore = '(\\.|[^a-z])+',
                 strip_accents = 1, lower = 1, overwrite = 0)
```

`PRAGMA` that creates a FTS index for the specified table.

<!-- markdownlint-disable MD056 -->

| Name | Type | Description |
|:--|:--|:----------|
| `input_table` | `VARCHAR` | Qualified name of specified table, e.g., `'table_name'` or `'main.table_name'` |
| `input_id` | `VARCHAR` | Column name of document identifier, e.g., `'document_identifier'` |
| `input_values...` | `VARCHAR` | Column names of the text fields to be indexed (vararg), e.g., `'text_field_1'`, `'text_field_2'`, ..., `'text_field_N'`, or `'\*'` for all columns in input_table of type `VARCHAR` |
| `stemmer` | `VARCHAR` | The type of stemmer to be used. One of `'arabic'`, `'basque'`, `'catalan'`, `'danish'`, `'dutch'`, `'english'`, `'finnish'`, `'french'`, `'german'`, `'greek'`, `'hindi'`, `'hungarian'`, `'indonesian'`, `'irish'`, `'italian'`, `'lithuanian'`, `'nepali'`, `'norwegian'`, `'porter'`, `'portuguese'`, `'romanian'`, `'russian'`, `'serbian'`, `'spanish'`, `'swedish'`, `'tamil'`, `'turkish'`, or `'none'` if no stemming is to be used. Defaults to `'porter'` |
| `stopwords` | `VARCHAR` | Qualified name of table containing a single `VARCHAR` column containing the desired stopwords, or `'none'` if no stopwords are to be used. Defaults to `'english'` for a pre-defined list of 571 English stopwords |
| `ignore` | `VARCHAR` | Regular expression of patterns to be ignored. Defaults to `'(\\.|[^a-z])+'`, ignoring all escaped and non-alphabetic lowercase characters |
| `strip_accents` | `BOOLEAN` | Whether to remove accents (e.g., convert `á` to `a`). Defaults to `1` |
| `lower` | `BOOLEAN` | Whether to convert all text to lowercase. Defaults to `1` |
| `overwrite` | `BOOLEAN` | Whether to overwrite an existing index on a table. Defaults to `0` |

<!-- markdownlint-enable MD056 -->

This `PRAGMA` builds the index under a newly created schema. The schema will be named after the input table: if an index is created on table `'main.table_name'`, then the schema will be named `'fts_main_table_name'`.

### `PRAGMA drop_fts_index`

```python
drop_fts_index(input_table)
```

Drops a FTS index for the specified table.

| Name | Type | Description |
|:--|:--|:-----------|
| `input_table` | `VARCHAR` | Qualified name of input table, e.g., `'table_name'` or `'main.table_name'` |

### `match_bm25` Function

```python
match_bm25(input_id, query_string, fields := NULL, k := 1.2, b := 0.75, conjunctive := 0)
```

When an index is built, this retrieval macro is created that can be used to search the index.

| Name | Type | Description |
|:--|:--|:----------|
| `input_id` | `VARCHAR` | Column name of document identifier, e.g., `'document_identifier'` |
| `query_string` | `VARCHAR` | The string to search the index for |
| `fields` | `VARCHAR` | Comma-separarated list of fields to search in, e.g., `'text_field_2, text_field_N'`. Defaults to `NULL` to search all indexed fields |
| `k` | `DOUBLE` | Parameter _k<sub>1</sub>_ in the Okapi BM25 retrieval model. Defaults to `1.2` |
| `b` | `DOUBLE` | Parameter _b_ in the Okapi BM25 retrieval model. Defaults to `0.75` |
| `conjunctive` | `BOOLEAN` | Whether to make the query conjunctive i.e., all terms in the query string must be present in order for a document to be retrieved |

### `stem` Function

```python
stem(input_string, stemmer)
```

Reduces words to their base. Used internally by the extension.

| Name | Type | Description |
|:--|:--|:----------|
| `input_string` | `VARCHAR` | The column or constant to be stemmed. |
| `stemmer` | `VARCHAR` | The type of stemmer to be used. One of `'arabic'`, `'basque'`, `'catalan'`, `'danish'`, `'dutch'`, `'english'`, `'finnish'`, `'french'`, `'german'`, `'greek'`, `'hindi'`, `'hungarian'`, `'indonesian'`, `'irish'`, `'italian'`, `'lithuanian'`, `'nepali'`, `'norwegian'`, `'porter'`, `'portuguese'`, `'romanian'`, `'russian'`, `'serbian'`, `'spanish'`, `'swedish'`, `'tamil'`, `'turkish'`, or `'none'` if no stemming is to be used. |

## Example Usage

Create a table and fill it with text data:

```sql
CREATE TABLE documents (
    document_identifier VARCHAR,
    text_content VARCHAR,
    author VARCHAR,
    doc_version INTEGER
);
INSERT INTO documents
    VALUES ('doc1',
            'The mallard is a dabbling duck that breeds throughout the temperate.',
            'Hannes Mühleisen',
            3),
           ('doc2',
            'The cat is a domestic species of small carnivorous mammal.',
            'Laurens Kuiper',
            2
           );
```

Build the index, and make both the `text_content` and `author` columns searchable.

```sql
PRAGMA create_fts_index(
    'documents', 'document_identifier', 'text_content', 'author'
);
```

Search the `author` field index for documents that are authored by `Muhleisen`. This retrieves `doc1`:

```sql
SELECT document_identifier, text_content, score
FROM (
    SELECT *, fts_main_documents.match_bm25(
        document_identifier,
        'Muhleisen',
        fields := 'author'
    ) AS score
    FROM documents
) sq
WHERE score IS NOT NULL
  AND doc_version > 2
ORDER BY score DESC;
```

| document_identifier |                             text_content                             | score |
|---------------------|----------------------------------------------------------------------|------:|
| doc1                | The mallard is a dabbling duck that breeds throughout the temperate. | 0.0   |

Search for documents about `small cats`. This retrieves `doc2`:

```sql
SELECT document_identifier, text_content, score
FROM (
    SELECT *, fts_main_documents.match_bm25(
        document_identifier,
        'small cats'
    ) AS score
    FROM documents
) sq
WHERE score IS NOT NULL
ORDER BY score DESC;
```

| document_identifier |                        text_content                        | score |
|---------------------|------------------------------------------------------------|------:|
| doc2                | The cat is a domestic species of small carnivorous mammal. | 0.0   |

> Warning The FTS index will not update automatically when input table changes.
> A workaround of this limitation can be recreating the index to refresh.
