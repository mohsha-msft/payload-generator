#!/bin/bash
## declare an array variable
source="placeholder_for_source"
destination="placeholder_for_destination"
version="placeholder_for_version"
while getopts s:d:v: flag
do
    case "${flag}" in
        s) source=${OPTARG};;
        d) destination=${OPTARG};;
        v) version=${OPTARG};;
        *)
            echo "Invalid flag";
                  exit 1;
              ;;
    esac
done

azcopybinaries/10.13.0/drop/azcopy_linux_amd64 copy "$source" "$destination" "--recursive"