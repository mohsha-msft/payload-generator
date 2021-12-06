#!/bin/bash

# Download AzCopy Binaries
bash download_azcopy_binaries.sh

# Create Local Source
number_of_files=100
number_of_entities_per_level=10
path="/mnt/f/RandomData/base"

locationA="$path/source/"
echo "Creating $locationA"
# Remove > /dev/null to display output of this command
bash local_file_generator.sh -n "$number_of_files" -e "$number_of_entities_per_level" -p "$locationA"
echo "Created $locationA"