#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/set_vars.sh

mkdir -p ${OUTPUT}/perf

rm ${OUTPUT}/perf/*

FLEXKV_SIZE=$((320*1024*1024*1024))
RUNTIME=600
WARMUP=200
DYNTIME=500
HOTFRAC1=0.15
HOTFRAC2=0.30

nice -20 numactl -N0 -m0,2 --physcpubind=19-23 -- ${APP_FOLDER}/llama.cpp/main -m ${MODEL} --threads 4 -p "The key to happiness in one short sentence is:" -n 120 -e > ${OUTPUT}/perf/llama.txt 2>&1 &
llama_pid=$!
${HEMEM}/wait-llama.sh ${OUTPUT}/perf/llama.txt
nice -20 numactl -N0 -m0,2 --physcpubind=14-18 -- env START_CPU=14 REQ_DRAM=0 ${BIN_FOLDER}/gups 4 0 37 8 36 1 ${OUTPUT}/perf/gups.txt > ${OUTPUT}/perf/gups-setup.txt 2>&1 &
gups_pid=$!
${HEMEM}/wait-gups.sh ${OUTPUT}/perf/gups-setup.txt
nice -20 numactl -N0 -m0,2 --physcpubind=8-13 -- ${APP_FOLDER}/flexkvs/kvsbench -t 4 -T ${RUNTIME} -w ${WARMUP} -h ${HOTFRAC1} -D ${DYNTIME} -H ${HOTFRAC2} 127.0.0.1:11211 -S ${FLEXKV_SIZE} > ${OUTPUT}/perf/flexkvs.txt &
flexkvs_pid=$!
${HEMEM}/wait-kvsbench.sh ${OUTPUT}/perf/flexkvs.txt
sleep 300
kill -s USR1 ${gups_pid}
wait ${flexkvs_pid}
kill -s USR2 ${gups_pid}
kill -9 ${llama_pid}