#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/set_vars.sh

nice -20 numactl -N0 -m0,2 --physcpubind=4-13 -- env START_CPU=4 ${BIN_FOLDER}/gups 8 0 38 8 36 0 ${OUTPUT}/gups_isolated.txt > ${OUTPUT}/gups-setup.txt &
gups_pid=$!
echo ${gups_pid}
${HEMEM}/wait-gups.sh ${OUTPUT}/gups-setup.txt
sleep 230
kill -s USR2 ${gups_pid}