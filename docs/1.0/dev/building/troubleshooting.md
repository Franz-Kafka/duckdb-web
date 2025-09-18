---
layout: docu
title: Troubleshooting
---

## R Package: The Build Only Uses a Single Thread

**Problem:**
By default, R compiles packages using a single thread, which causes the build to be slow.

**Solution:**
To parallelize the compilation, create or edit the `~/.R/Makevars` file, and add a line like the following:

```ini
MAKEFLAGS = -j8
```

The above will parallelize the compilation using 8 threads. On Linux/macOS, you can add the following to use all of the machine's threads:

```ini
MAKEFLAGS = -j$(nproc)
```

However, note that, the more threads that are used, the higher the RAM consumption. If the system runs out of RAM while compiling, then the R session will crash.

## R Package on Linux AArch64: `too many GOT entries` Build Error

**Problem:**
Building the R package on Linux running on an ARM64 architecture (AArch64) may result in the following error message:

```console
/usr/bin/ld: /usr/include/c++/10/bits/basic_string.tcc:206:
warning: too many GOT entries for -fpic, please recompile with -fPIC
```

**Solution:**
Create or edit the `~/.R/Makevars` file. This example also contains the [flag to parallelize the build](#r-package-the-build-only-uses-a-single-thread):

```ini
ALL_CXXFLAGS = $(PKG_CXXFLAGS) -fPIC $(SHLIB_CXXFLAGS) $(CXXFLAGS)
MAKEFLAGS = -j$(nproc)
```

When making this change, also consider [making the build parallel](#r-package-the-build-only-uses-a-single-thread).

## Python Package: `No module named 'duckdb.duckdb'` Build Error

**Problem:**
Building the Python package succeeds but the package cannot be imported:

```bash
cd tools/pythonpkg/
python3 -m pip install .
python3 -c "import duckdb"
```

This returns the following error message:

```console
Traceback (most recent call last):
  File "<string>", line 1, in <module>
  File "/duckdb/tools/pythonpkg/duckdb/__init__.py", line 4, in <module>
    import duckdb.functional as functional
  File "/duckdb/tools/pythonpkg/duckdb/functional/__init__.py", line 1, in <module>
    from duckdb.duckdb.functional import (
ModuleNotFoundError: No module named 'duckdb.duckdb'
```

**Solution:**
The problem is caused by Python trying to import from the current working directory.
To work around this, navigate to a different directory (e.g., `cd ..`) and try running Python import again.

## Python Package on macOS: Building the httpfs Extension Fails

**Problem:**
The build fails on macOS when both the [`httpfs` extension]({% link docs/1.0/extensions/httpfs/overview.md %}) and the Python package are included:

```batch
GEN=ninja BUILD_PYTHON=1 BUILD_HTTPFS=1 make
```

```console
ld: library not found for -lcrypto
clang: error: linker command failed with exit code 1 (use -v to see invocation)
error: command '/usr/bin/clang++' failed with exit code 1
ninja: build stopped: subcommand failed.
make: *** [release] Error 1
```

**Solution:**
In general, we recommended using the nightly builds, available under GitHub main on the [installation page]({% link docs/installation/index.html %}).
If you would like to build DuckDB from source, avoid using the `BUILD_PYTHON=1` flag unless you are actively developing the Python library.
Instead, first build the `httpfs` extension (if required), then build and install the Python package separately using pip:

```batch
GEN=ninja BUILD_HTTPFS=1 make
```

If the next line complains about pybind11 being missing, or `--use-pep517` not being supported, make sure you're using a modern version of pip and setuptools.
`python3-pip` on your OS may not be modern, so you may need to run `python3 -m pip install pip -U` first.

```batch
python3 -m pip install tools/pythonpkg --use-pep517 --user
```

## Linux: Building the httpfs Extension Fails

**Problem:**
When building the [`httpfs` extension]({% link docs/1.0/extensions/httpfs/overview.md %}) on Linux, the build may fail with the following error.

```console
CMake Error at /usr/share/cmake-3.22/Modules/FindPackageHandleStandardArgs.cmake:230 (message):
  Could NOT find OpenSSL, try to set the path to OpenSSL root folder in the
  system variable OPENSSL_ROOT_DIR (missing: OPENSSL_CRYPTO_LIBRARY
  OPENSSL_INCLUDE_DIR)
```

**Solution:**
Install the `libssl-dev` library.

```batch
sudo apt-get install -y libssl-dev
```

Then, build with:

```batch
GEN=ninja BUILD_HTTPFS=1 make
```