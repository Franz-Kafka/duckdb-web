#!/usr/bin/env bash
set -xeuo pipefail

if [ "${1-}" = "" ]
then
    echo >&2 "Usage: $0 duckdb_dir_with_release_duckdb"
    exit 1
fi

DUCKDB=$1;
echo "Generating docs using duckdb source in $DUCKDB"

python3 ./scripts/generate_config_docs.py $DUCKDB/build/release/duckdb
python3 ./scripts/generate_c_api_docs.py $DUCKDB
python3 ./scripts/generate_python_docs.py
python3 ./scripts/generate_sql_function_docs.py $DUCKDB/build/release/duckdb
node ./scripts/generate_nodejs_docs.js $DUCKDB/../duckdb-node
python3 ./scripts/generate_function_json.py --source $DUCKDB --binary $DUCKDB/build/release/duckdb
