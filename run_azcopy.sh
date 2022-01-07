#!/bin/bash
## declare an array variable
source="placeholder_for_source"
destination="placeholder_for_destination"
version="placeholder_for_version"
operation="copy"
while getopts s:d:v:o: flag
do
    case "${flag}" in
        s) source=${OPTARG};;
        d) destination=${OPTARG};;
        v) version=${OPTARG};;
        o) operation=${OPTARG};;
        *)
            echo "Invalid flag";
                  exit 1;
              ;;
    esac
done

echo "Using AzCopy Version:"
azcopy_binaries/$version/drop/azcopy_linux_amd64 --version
azcopy_binaries/$version/drop/azcopy_linux_amd64 $operation "$source" "$destination" "--recursive"