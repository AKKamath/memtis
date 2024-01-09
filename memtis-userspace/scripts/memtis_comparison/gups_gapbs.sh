#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/set_vars.sh

mkdir -p ${OUTPUT}

nice -20 numactl -N0 -m0,2 --physcpubind=14-23 -- env OMP_THREAD_LIMIT=8 ${APP_FOLDER}/gapbs/bc -n 50 -g 29 > ${OUTPUT}/gapbs.txt &
gapbs_pid=$!
perf stat -e instructions -I 1000 -p ${gapbs_pid} -o ${OUTPUT}/gapbs-ipc.txt &
sleep 10
kill -s SIGUSR1 ${gapbs_pid}
${HEMEM}/wait-gapbs.sh ${OUTPUT}/gapbs.txt
nice -20 numactl -N0 -m0,2 --physcpubind=4-13 -- env START_CPU=4 ${BIN_FOLDER}/gups 8 0 38 8 36 0 ${OUTPUT}/gups-gapbs.txt > ${OUTPUT}/gups-gapbs-setup.txt &
gups_pid=$!
${HEMEM}/wait-gups.sh ${OUTPUT}/gups-gapbs-setup.txt
sleep 230
kill -s USR2 ${gups_pid}
sleep 1
kill -9 ${gups_pid}
kill -9 ${gapbs_pid}