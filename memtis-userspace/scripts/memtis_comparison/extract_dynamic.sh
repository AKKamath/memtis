file=$1

# seconds=1 TP: total=1.2048 mops  50p=1 us  90p=2 us  95p=2 us  99p=3 us  99.9p=4 us  99.99p=7 us  
echo "Throughput (MOPS)"
grep -oE "total=[0-9].[0-9]+ mops" $file | grep -oE "[0-9].[0-9]+"
echo "90% latency"
grep -oE " 90p=[0-9]+ us" $file | grep -oE "=[0-9]+" | grep -oE "[0-9]+"
echo "95% latency"
grep -oE " 95p=[0-9]+ us" $file | grep -oE "=[0-9]+" | grep -oE "[0-9]+"
echo "99% latency"
grep -oE " 99p=[0-9]+ us" $file | grep -oE "=[0-9]+" | grep -oE "[0-9]+"