file=$1

# 4530529539131302	0.0089550000	50p=470 ns	90p=1960 ns	95p=-1 ns	99p=-1 ns	99.9p=-1 ns	99.99p=-1 ns 
echo "Throughput (GUPS)"
grep -oE "0\.[0-9]+" $file
echo "50% latency"
grep -oE "50p=[0-9]+ ns" $file | grep -oE "=[0-9]+" | grep -oE "[0-9]+"
echo "90% latency"
grep -oE "90p=[0-9]+ ns" $file | grep -oE "=[0-9]+" | grep -oE "[0-9]+"
echo "99% latency"
grep -oE "99p=[0-9]+ ns" $file | grep -oE "=[0-9]+" | grep -oE "[0-9]+"