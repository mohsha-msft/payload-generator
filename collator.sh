#!/bin/bash
# A (Local) --- upload ---> B (Container1) ---- S2S ---> C (container2) --- Download ---> D (Local)
#versions=("10.4.3" "10.5.1" "10.7.0" "10.8.0" "10.12.0" "10.13.0")
path="/mnt/f/RandomData/base"
versions=("10.5.1" "10.7.0" "10.13.0")
sas_validity_in_hrs=24

while getopts s:p: flag
do
    case "${flag}" in
        s) sas_validity_in_hrs=${OPTARG};;
        p) path=${OPTARG};;
        *)
            echo "Invalid flag";
                  exit 1;
              ;;
    esac
done

for version in "${versions[@]}"
do
   bash azcopy_copy_loop.sh -p "$path" -s "$sas_validity_in_hrs" -v "$version"
   bash cleanup.sh  -p "$path" -v "$version"
done

# Publish result to blob container is not ready for the time being.
#bash publish_results.sh