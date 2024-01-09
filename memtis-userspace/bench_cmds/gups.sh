#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../scripts/memtis_comparison/set_vars.sh

BENCH_RUN="${BIN}/gups_isolated.sh"
BENCH_DRAM="131072MB"

export BENCH_RUN
export BENCH_DRAM
