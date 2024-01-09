#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/set_vars.sh

mkdir -p ${OUTPUT}

nice -20 numactl -N0 -m0,2 --physcpubind=14-23 -- env OMP_THREAD_LIMIT=8 ${APP_FOLDER}/nas-bt-c-benchmark/NPB-OMP/bin/bt.E -n 50 -g 28 > ${OUTPUT}/bt.txt &
bt_pid=$!
perf stat -e instructions -I 1000 -p ${bt_pid} -o ${OUTPUT}/bt-ipc.txt &
sleep 10
kill -s SIGUSR1 ${bt_pid}
${HEMEM}/wait-bt.sh ${OUTPUT}/bt.txt
nice -20 numactl -N0 -m0,2 --physcpubind=4-13 -- env START_CPU=4 ${BIN_FOLDER}/gups 8 0 38 8 36 0 ${OUTPUT}/gups-bt.txt > ${OUTPUT}/gups-bt-setup.txt &
gups_pid=$!
${HEMEM}/wait-gups.sh ${OUTPUT}/gups-bt-setup.txt
sleep 230
kill -s USR2 ${gups_pid}
sleep 1
kill -9 ${gups_pid}
kill -9 ${bt_pid}