---
layout: docu
title: Why DuckDB
---

There are many database management systems (DBMS) out there. But there is [no one-size-fits all database system](https://blobs.duckdb.org/papers/stonebraker-centintemel-one-size-fits-all-icde-2015.pdf). All take different trade-offs to better adjust to specific use cases. DuckDB is no different. Here, we try to explain what goals DuckDB has and why and how we try to achieve those goals through technical means. To start with, DuckDB is a [relational (table-oriented) DBMS](https://en.wikipedia.org/wiki/Relational_database) that supports the [Structured Query Language (SQL)](https://en.wikipedia.org/wiki/SQL).

## Key Characteristics of DuckDB

### Simple

SQLite is the [world's most widely deployed DBMS](https://www.sqlite.org/mostdeployed.html). Simplicity in installation, and embedded in-process operation are central to its success. DuckDB adopts these ideas of simplicity and embedded operation.

DuckDB has **no external dependencies**, neither for compilation nor during run-time. For releases, the entire source tree of DuckDB is compiled into two files, a header and an implementation file, a so-called "amalgamation". This greatly simplifies deployment and integration in other build processes. For building, all that is required to build DuckDB is a working C++11 compiler.

For DuckDB, there is no DBMS server software to install, update and maintain. DuckDB does not run as a separate process, but completely **embedded within a host process**. For the analytical use cases that DuckDB targets, this has the additional advantage of **high-speed data transfer** to and from the database. In some cases, DuckDB can process foreign data without copying. For example, the DuckDB Python package can run queries directly on Pandas data without ever importing or copying any data.

### Portable

Thanks to having no dependencies, DuckDB is extremely portable. It can be compiled for all major operating systems (Linux, macOS, Windows) and CPU architectures (x86, ARM). It can be deployed from small, resource-constrained edge devices to large multi-terabyte memory servers with 100+ CPU cores. Using [DuckDB-Wasm]({% link docs/stable/clients/wasm/overview.md %}), DuckDB can also run in web browsers and even on mobile phones.

DuckDB provides [APIs for Java, C, C++, Go, Node.js and other languages]({% link docs/stable/clients/overview.md %}).

### Feature-Rich

DuckDB provides serious data management features. There is extensive support for **complex queries** in SQL with a large function library, window functions, etc. DuckDB provides **transactional guarantees** (ACID properties) through our custom, bulk-optimized [Multi-Version Concurrency Control (MVCC)](https://en.wikipedia.org/wiki/Multiversion_concurrency_control). Data can be stored in persistent, **single-file databases**. DuckDB supports secondary indexes to speed up queries trying to find a single table entry.

DuckDB is deeply integrated into Python and R for efficient interactive data analysis.

### Fast

DuckDB is designed to support **analytical query workloads**, also known as [online analytical processing (OLAP)](https://en.wikipedia.org/wiki/Online_analytical_processing). These workloads are characterized by complex, relatively long-running queries that process significant portions of the stored dataset, for example aggregations over entire tables or joins between several large tables. Changes to the data are expected to be rather large-scale as well, with several rows being appended, or large portions of tables being changed or added at the same time.

To efficiently support this workload, it is critical to reduce the amount of CPU cycles that are expended per individual value. The state of the art in data management to achieve this are either [vectorized or just-in-time query execution engines](https://www.vldb.org/pvldb/vol11/p2209-kersten.pdf). DuckDB uses a **columnar-vectorized query execution engine**, where queries are still interpreted, but a large batch of values (a "vector") are processed in one operation. This greatly reduces overhead present in traditional systems such as PostgreSQL, MySQL or SQLite which process each row sequentially. Vectorized query execution leads to far better performance in OLAP queries.

### Extensible

DuckDB offers a [flexible extension mechanism]({% link docs/stable/core_extensions/overview.md %}) that allows defining new data types, functions, file formats and new SQL syntax. In fact, many of DuckDB's key features, such as support for the [Parquet file format]({% link docs/stable/data/parquet/overview.md %}), [JSON]({% link docs/stable/data/json/overview.md %}), [time zones]({% link docs/stable/core_extensions/icu.md %}), and support for the [HTTP(S) and S3 protocols]({% link docs/stable/core_extensions/httpfs/overview.md %}) are implemented as extensions. Extensions also [work in DuckDB Wasm]({% post_url 2023-12-18-duckdb-extensions-in-wasm %}).
User contributions are available as [community extensions]({% link community_extensions/index.md %}).

### Free

DuckDB's development started while the main developers were public servants in the Netherlands. We see it as our responsibility and duty to society to make the results of our work freely available to anyone in the Netherlands or elsewhere. This is why DuckDB is released under the very permissive [MIT License](https://en.wikipedia.org/wiki/MIT_License) and the project's intellectual property is held by the [DuckDB Foundation]({% link foundation/index.html %}). We invite contributions from anyone provided they adhere to our [Code of Conduct]({% link code_of_conduct.md %}).

### Thoroughly Tested

While DuckDB was originally created by a research group, it was never intended to be a research prototype. Instead, it was intended to become a stable and mature database system. To facilitate this stability, DuckDB is intensively tested using [Continuous Integration](https://github.com/duckdb/duckdb/actions). DuckDB's test suite currently contains millions of queries, and includes queries adapted from the test suites of SQLite, PostgreSQL, and MonetDB. Tests are repeated on a wide variety of platforms and compilers. Every pull request is checked against the full test setup and only merged if it passes.

In addition to this test suite, we run various tests that stress DuckDB under heavy loads. We run the [TPC-H]({% link docs/stable/core_extensions/tpch.md %}) and [TPC-DS]({% link docs/stable/core_extensions/tpcds.md %}) benchmarks, and run various tests where DuckDB is used by many clients in parallel.

## Peer-Reviewed Papers and Thesis Works

* [Runtime-Extensible Parsers]({% link pdf/CIDR2025-muehleisen-raasveldt-extensible-parsers.pdf %}) (CIDR 2025)
* [Robust External Hash Aggregation in the Solid State Age]({% link pdf/ICDE2024-kuiper-boncz-muehleisen-out-of-core.pdf %}) (ICDE 2024)
* [These Rows Are Made for Sorting and That's Just What We'll Do]({% link pdf/ICDE2023-kuiper-muehleisen-sorting.pdf %}) (ICDE 2023)
* [Join Order Optimization with (Almost) No Statistics](https://blobs.duckdb.org/papers/tom-ebergen-msc-thesis-join-order-optimization-with-almost-no-statistics.pdf) (Master thesis, 2022)
* [DuckDB-Wasm: Fast Analytical Processing for the Web]({% link pdf/VLDB2022-kohn-duckdb-wasm.pdf %}) (VLDB 2022 Demo)
* [Data Management for Data Science - Towards Embedded Analytics]({% link pdf/CIDR2020-raasveldt-muehleisen-duckdb.pdf %}) (CIDR 2020)
* [DuckDB: an Embeddable Analytical Database]({% link pdf/SIGMOD2019-demo-duckdb.pdf %}) (SIGMOD 2019 Demo)

## Projects Built with/for DuckDB

To learn about projects using DuckDB, visit the [Awesome DuckDB repository](https://github.com/davidgasquez/awesome-duckdb).

## Standing on the Shoulders of Giants

DuckDB uses some components from various open-source projects and draws inspiration from scientific publications. We are very grateful for this. Here is an overview:

* **Execution engine:** The vectorized execution engine is inspired by the paper [MonetDB/X100: Hyper-Pipelining Query Execution](http://cidrdb.org/cidr2005/papers/P19.pdf) by Peter Boncz, Marcin Zukowski and Niels Nes. MonetDB/X100 later became the [Vectorwise (Actian Vector) database system](https://ir.cwi.nl/pub/19958/19958B.pdf).
* **Optimizer:** DuckDB's optimizer draws inspiration from the papers [Dynamic programming strikes back](https://15721.courses.cs.cmu.edu/spring2020/papers/20-optimizer2/p539-moerkotte.pdf) by Guido Moerkotte and Thomas Neumann as well as [Unnesting Arbitrary Queries](http://www.btw-2015.de/res/proceedings/Hauptband/Wiss/Neumann-Unnesting_Arbitrary_Querie.pdf) by Thomas Neumann and Alfons Kemper.
* **Concurrency control:** Our MVCC implementation is inspired by the paper [Fast Serializable Multi-Version Concurrency Control for Main-Memory Database Systems](https://db.in.tum.de/~muehlbau/papers/mvcc.pdf) by Thomas Neumann, Tobias Mühlbauer and Alfons Kemper.
* **Secondary indexes:** DuckDB has support for secondary indexes based on the paper [The Adaptive Radix Tree: ARTful Indexing for Main-Memory Databases](https://db.in.tum.de/~leis/papers/ART.pdf) by Viktor Leis, Alfons Kemper and Thomas Neumann.
* **SQL window functions:** DuckDB's window functions implementation uses Segment Tree Aggregation as described in the paper [Efficient Processing of Window Functions in Analytical SQL Queries](https://www.vldb.org/pvldb/vol8/p1058-leis.pdf) by Viktor Leis, Kan Kundhikanjana, Alfons Kemper and Thomas Neumann.
* **SQL inequality joins:** DuckDB's inequality join implementation uses the IEJoin algorithm as described in the paper [Lightning Fast and Space Efficient Inequality Joins](https://vldb.org/pvldb/vol8/p2074-khayyat.pdf)
Zuhair Khayyat, William Lucia, Meghna Singh, Mourad Ouzzani, Paolo Papotti, Jorge-Arnulfo Quiané-Ruiz, Nan Tang and Panos Kalnis.
* **Compression of floating-point values:** DuckDB supports the multiple algorithms for compressing floating-point values:
    * [Chimp](https://vldb.org/pvldb/vol15/p3058-liakos.pdf) by Panagiotis Liakos, Katia Papakonstantinopoulou and Yannis Kotidi
    * [Patas](https://github.com/duckdb/duckdb/pull/5044), an in-house development
    * [ALP (adaptive lossless floating-point compression)](https://dl.acm.org/doi/pdf/10.1145/3626717) by Azim Afroozeh, Leonard Kuffo and Peter Boncz, who also [contributed their implementation](https://github.com/duckdb/duckdb/pull/9635)
* **SQL Parser:** We use the PostgreSQL parser that was [repackaged as a stand-alone library](https://github.com/lfittl/libpg_query). The translation to our own parse tree is inspired by [Peloton](https://pelotondb.io).
* **Shell:** We use the [SQLite shell](https://sqlite.org/cli.html) to work with DuckDB.
* **Regular expressions:** DuckDB uses Google's [RE2](https://github.com/google/re2) regular expression engine.
* **String formatting:** DuckDB uses the [fmt](https://github.com/fmtlib/fmt) string formatting library.
* **UTF wrangling:** DuckDB uses the [utf8proc](https://juliastrings.github.io/utf8proc/) library to check and normalize UTF8.
* **Collation and time:** DuckDB uses the [ICU](https://unicode-org.github.io/icu/) library for collation, time zone, and calendar support.
* **Test framework:** DuckDB uses the [Catch2](https://github.com/catchorg/Catch2) unit test framework.
* **Test cases:** We use the [SQL Logic Tests from SQLite](https://www.sqlite.org/sqllogictest/doc/trunk/about.wiki) to test DuckDB.
* **Result validation:** [Manuel Rigger](https://www.manuelrigger.at) used his excellent [SQLancer](https://github.com/sqlancer/sqlancer) tool to verify DuckDB result correctness.
* **Query fuzzing:** We use [SQLsmith](https://github.com/anse1/sqlsmith) via the [`sqlsmith` extension]({% link docs/stable/core_extensions/sqlsmith.md %}) to generate random queries for additional testing.
* **JSON parser:** We use [yyjson](https://github.com/ibireme/yyjson), a high performance JSON library written in ANSI C, to parse JSON in DuckDB's [JSON Extension]({% link docs/stable/data/json/overview.md %}).
