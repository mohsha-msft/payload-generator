#!/bin/bash

# Download AzCopy Binaries
bash download_azcopy_binaries.sh

# Create Local Source
number_of_files=100
number_of_entities_per_level=10
path="/mnt/f/RandomData/base"

while getopts n:e:p: flag
do
    case "${flag}" in
        n) number_of_files=${OPTARG};;
        e) number_of_entities_per_level=${OPTARG};;
        p) path=${OPTARG};;
        *)
            echo "Invalid flag";
                  exit 1;
              ;;
    esac
done


locationA="$path/source/"
echo "Creating $locationA"
# Remove > /dev/null to display output of this command
bash local_file_generator.sh -n "$number_of_files" -e "$number_of_entities_per_level" -p "$locationA"
echo "Created $locationA"