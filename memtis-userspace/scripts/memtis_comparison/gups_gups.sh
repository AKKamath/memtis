#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/set_vars.sh

mkdir -p ${OUTPUT}

nice -20 numactl -N0 -m0,2 --physcpubind=13-22 -- env START_CPU=13 ${BIN_FOLDER}/gups 8 0 38 8 36 0 ${OUTPUT}/bggups.txt > ${OUTPUT}/bggups-setup.txt &
bggups_pid=$!
perf stat -e instructions -I 1000 -p ${bggups_pid} -o ${OUTPUT}/bggups-ipc.txt &
${HEMEM}/wait-gups.sh ${OUTPUT}/bggups-setup.txt
nice -20 numactl -N0 -m0,2 --physcpubind=3-12 -- env START_CPU=3 ${BIN_FOLDER}/gups 8 0 38 8 36 0 ${OUTPUT}/gups-gups.txt > ${OUTPUT}/gups-gups-setup.txt &
gups_pid=$!
${HEMEM}/wait-gups.sh ${OUTPUT}/gups-gups-setup.txt
sleep 230
kill -s USR2 ${gups_pid}
sleep 1
kill -9 ${gups_pid}
kill -9 ${bggups_pid}