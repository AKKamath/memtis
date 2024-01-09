## Steps for multi-process comparison with Memtis
1. Follow the original guide to setup your machine with the Memtis Linux kernel.
2. Open [memtis-userspace/scripts/memtis_comparison/set_vars.sh](memtis-userspace/scripts/memtis_comparison/set_vars.sh) and update with your respective directories.
2. Open [memtis-userspace/scripts/run_bench.sh](memtis-userspace/scripts/run_bench.sh) line 13 and update with your respective directory.
3. Run ```source setup.sh``` in the top-level directory after every reboot to setup the NUMA node with PMEM.
4. Go to memtis-userspace and run ```sudo ./scripts/run_bench.sh -B [EXPERIMENT]``` where [EXPERIMENT] is one of ```gups```, ```gups-gups```,  ```gups-gapbs```, or ```gups-bt```.
5. A new folder comparison_results will be created in top-level directory containing all results.
6. You may need to reboot after every experiment due to CPU deadlocks that seem to occur.

## Steps to create new multi-process workload with Memtis
1. Create a new script file in [memtis-userspace/scripts/memtis_comparison](memtis-userspace/scripts/memtis_comparison).
2. In this script add all the commands required to run the application(s). Make sure this script is self-contained, and path references aren't relative. Memtis will treat this script and all applications launched within it like a single process and manage tiering of memory for it.
3. Create a new file in [memtis-userspace/bench_cmds](memtis-userspace/bench_cmds). For example memtis-userspace/bench_cmds/test_app.sh
4. In this file set BENCH_RUN to the script file that runs all the applications and BENCH_DRAM to the DRAM the application is limited to. An example is given below for BT:
```
#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/../scripts/memtis_comparison/set_vars.sh

BENCH_RUN="${BIN}/gups_bt.sh"
BENCH_DRAM="131072MB"

export BENCH_RUN
export BENCH_DRAM
```
5. Go to memtis-userspace and run ```sudo ./scripts/run_bench.sh -B test_app``` to run the new test_app script you created. Replace test_app with whatever you named your script.


Original README for MEMTIS preserved below:
# MEMTIS: Efficient Memory Tiering with Dynamic Page Classification and Page Size Determination

## System configuration
* Fedora 33 server
* Two 20-core Intel(R) Xeon(R) Gold 5218R CPU @ 2.10GHz
* 6 x 16GB DRAM per socket
* 6 x 128GB Intel Optane DC Persistent Memory per socket

MEMTIS currently supports two system configurations
* DRAM + Intel DCPMM (used only single socket)
* local DRAM + remote DRAM (used two socket, CXL emulation mode)

## Source code information
See linux/

You have to enable CONFIG\_HTMM when compiling the linux source.
```
make menuconfig
...
CONFIG_HTMM=y
...
```

### Dependencies
There are nothing special libraries for MEMTIS itself.

(You just need to install libraries for Linux compilation.)

## For experiments
### Userspace scripts
See memtis-userspace/

Please read memtis-userspace/README.md for detailed explanations

### Setting tiered memory systems with Intel DCPMM
* Reconfigures a namespace with devdax mode
```
sudo ndctl create-namespace -f -e namespace0.0 --mode=devdax
...
```
* Reconfigures a dax device with system-ram mode (KMEM DAX)
```
sudo daxctl reconfigure-device dax0.0 --mode=system-ram
...
```

### Preparing benchmarks
We used open-sourced benchmarks except SPECCPU2017.

We provided links to each benchmark source in memtis-userspace/bench\_dir/README.md

### Running benchmarks
It is necessary to create/update a simple script for each benchmark.
If you want to execute *XSBench*, for instance, you have to create memtis-userspace/bench\_cmds/XSBench.sh.

This is a sample.
```
# memtis-userspace/bench_cmds/XSBench.sh

BIN=/path/to/benchmark
BENCH_RUN="${BIN}/XSBench [Options]"

# Provide the DRAM size for each memory configuration setting.
# You must first check the resident set size of a benchmark.
if [[ "x${NVM_RATIO}" == "x1:16" ]]; then
    BENCH_DRAM="3850MB"
elif [[ "x${NVM_RATIO}" == "x1:8" ]]; then
    BENCH_DRAM="7200MB"
elif [[ "x${NVM_RATIO}" == "x1:2" ]]; then
    BENCH_DRAM="21800MB"
fi

# required
export BENCH_RUN
export BENCH_DRAM

```

#### Test
```
cd memtis-userspace/

# check running options
./scripts/run_bench.sh --help

# create an executable binary file
make

# run
sudo ./scripts/run_bench.sh -B ${BENCH} -R ${MEM_CONFIG} -V ${TEST_NAME}
## or use scripts
sudo ./run-fig5-6-10.sh
sudo ./run-fig7.sh
...
```

#### Tips for setting other tiered memory systems
See memtis-userspace/README.md

## Commit number used for artifact evaluation
174ca88

## License
<a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">Creative Commons Attribution-NonCommercial 4.0 International License</a>.

## Bibtex
To be updated 

## Authors
- Taehyung Lee (Sungkyunkwan University, SKKU) <taehyunggg@skku.edu>, <taehyung.tlee@gmail.com>
- Sumit Kumar Monga (Virginia Tech) <sumitkm@vt.edu>
- Changwoo Min (Virginia Tech) <changwoo@vt.edu>
- Young Ik Eom (Sungkyunkwan University, SKKU) <yieom@skku.edu>
