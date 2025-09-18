---
layout: docu
redirect_from:
- docs/archive/0.9.2/guides/python/install
- docs/archive/0.9.1/guides/python/install
- docs/archive/0.9.0/guides/python/install
title: Install the Python Client
---

The latest release of the Python client can be installed using `pip`.

```batch
pip install duckdb
```

The pre-release Python client can be installed using `--pre`.

```batch
pip install duckdb --upgrade --pre
```

The latest Python client can be installed from source from the [`tools/pythonpkg` directory in the DuckDB GitHub repository](https://github.com/duckdb/duckdb/tree/main/tools/pythonpkg).

```batch
BUILD_PYTHON=1 GEN=ninja make
cd tools/pythonpkg
python setup.py install
```