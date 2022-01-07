#!/bin/bash
set -e
# A (Local) --- upload ---> B (Container1) ---- S2S ---> C (container2) --- Download ---> D (Local)
#versions=("10.4.3" "10.5.1" "10.7.0" "10.8.0" "10.12.0" "10.13.0")
path="/mnt/f/RandomData/base"
versions=("10.4.3")
sas_validity_in_hrs=24
operation="copy"
while getopts s:p:o: flag
do
    case "${flag}" in
        s) sas_validity_in_hrs=${OPTARG};;
        p) path=${OPTARG};;
        o) operation=${OPTARG};;
        *)
            echo "Invalid flag";
                  exit 1;
              ;;
    esac
done

# shellcheck disable=SC2034
if [ $operation == "copy" ]; then
    for i in {1..1};
    do
       for version in "${versions[@]}"
       do
          echo "Running AzCopy Copy Loop($i) for version: $version"
          bash azcopy_copy_loop.sh -p "$path" -s "$sas_validity_in_hrs" -v "$version"
          bash cleanup.sh  -p "$path" -v "$version"
       done
    done
else
    for i in {1..1};
    do
       for version in "${versions[@]}"
       do
          echo "Running AzCopy Sync Loop($i) for version: $version"
          bash azcopy_sync_destination_constructor.sh -p "$path" -s "$sas_validity_in_hrs" -v "$version"
          bash azcopy_sync_loop.sh -p "$path" -s "$sas_validity_in_hrs" -v "$version"
          bash cleanup.sh  -p "$path" -v "$version"
          rm -rf $path/selected
       done
    done
fi

# Publish result to blob container is not ready for the time being.
#bash publish_results.sh