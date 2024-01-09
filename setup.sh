sudo ndctl create-namespace -f -e namespace0.0 --mode=devdax
sudo daxctl reconfigure-device dax0.0 --mode=system-ram
numactl -H