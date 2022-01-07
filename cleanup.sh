#!/bin/bash
# Perform cleanup
while getopts p:v: flag
do
    case "${flag}" in
        p) path=${OPTARG};;
        v) version=${OPTARG};;
        *)
            echo "Invalid flag";
                  exit 1;
              ;;
    esac
done

echo "Stating Cleanup ================================================================================================="
#echo "Deleting locationA"
#locationA="$path/source"
#rm -rf $locationA

echo "Deleting locationB"
locationB=$( tail -n 1 locationB$version.csv )
go run containers_handler.go "delLocB" "$locationB"

echo "Deleting locationC"
locationC=$( tail -n 1 locationC$version.csv )
go run containers_handler.go "delLocC" "$locationC"

echo "Deleting locationD"
locationD="$path/destination"
rm -rf $locationD

## Deleting AzCopy Binaries
#rm -rf azcopy_binaries

# Deleting all the CSV files created during the process
rm location*.csv
