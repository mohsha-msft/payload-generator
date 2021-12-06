#!/bin/bash
# A (Local) --- upload ---> B (Container1) ---- S2S ---> C (container2) --- Download ---> D (Local)
#versions=("10.4.3" "10.5.1" "10.7.0" "10.8.0" "10.12.0" "10.13.0")
path="/mnt/f/RandomData/base"
versions=("10.5.1" "10.7.0")
sas_validity_in_hrs=24

for version in "${versions[@]}"
do
   bash per_azcopy_operation.sh -p "$path" -s "$sas_validity_in_hrs" -v "$version"
   bash cleanup.sh -v "$version"
done

### Let's perform local source clean up too.
#echo "Deleting locationA and locationD"
#rm -rf $path/*
#rm -rf azcopy_binaries
#rm -rf *.csv
#rm -rf *.txt
