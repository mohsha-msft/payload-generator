#!/bin/bash
set -e
path="/mnt/f/RandomData/base"
sas_validity_in_hrs=24
version="10.13.0"
operation="sync"
# shellcheck disable=SC2006

while getopts p:s:v: flag
do
    case "${flag}" in
        p) path=${OPTARG};;
        s) sas_validity_in_hrs=${OPTARG};;
        v) version=${OPTARG};;
        *)
            echo "Invalid flag";
                  exit 1;
              ;;
    esac
done
# shellcheck disable=SC2002
taskId="$(cat /dev/urandom | tr -dc 'a-zA-Z' | fold -w 15 | head -n 1)-$version"
locationA="$path/source/"
echo "Created $locationA"

echo "Run Upload Test ================================================================================================="
locationB=$( tail -n 1 locationB$version.csv )
echo "Starting $operation upload between $locationA and $locationB using AzCopy $version"
bash run_azcopy.sh -o "$operation" -v "$version" -s "$locationA" -d "$locationB" > results/performance_upload_$operation_$taskId.txt

echo "Run S2S Test ===================================================================================================="
locationC=$( tail -n 1 locationC$version.csv )
echo "Starting $operation S2S transfer between $locationB and $locationC using AzCopy $version"
bash run_azcopy.sh -o "$operation" -v "$version" -s "$locationB" -d "$locationC" > results/performance_s2s_$operation_$taskId.txt

echo "Run Download Test ==============================================================================================="
locationD="$path/destination/"
echo "Starting $operation download between $locationC and $locationD using AzCopy $version"
bash run_azcopy.sh -o "$operation" -v "$version" -s "$locationC" -d "$locationD" > results/performance_download_$operation_$taskId.txt