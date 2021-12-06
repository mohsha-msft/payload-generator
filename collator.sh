#!/bin/bash
number_of_files=100
number_of_entities_per_level=10
path="/mnt/f/RandomData/base"
sas_validity_in_hrs=24

# Download AzCopy Binaries

locationA="$path/source/"
bash local_file_generator.sh -n "$number_of_files" -e "$number_of_entities_per_level" -p "$locationA"
echo "Created $locationA"
# A (Local) --- upload ---> B (Container1) ---- S2S ---> C (container2) --- Download ---> D (Local)

# Run Upload Test

# Create destination -> Location.csv will contain source and destination

go run containers_handler.go "locB" "$locationA" "$sas_validity_in_hrs"
locationB=$( tail -n 1 locationB.csv )
echo "Created $locationB"

echo "Starting upload between $locationA and $locationB"
bash run_upload.sh -v "10.13.0" -s "$locationA" -d "$locationB" > uploadazcopy10.13.0.txt

# Run S2S Test
go run containers_handler.go "locC" "$locationB" "$sas_validity_in_hrs"
locationC=$( tail -n 1 locationC.csv )
echo "Created $locationC"

# Run Download Test
locationD="$path/destination/"
mkdir -p "$locationD"
echo "Created $locationD"

# Perform cleanup

# delete A->B->C->D
echo "Deleting locationA"
# shellcheck disable=SC2115
rm -rf $path/*

echo "Deleting locationB"
go run containers_handler.go "delLocB" "$locationB"

echo "Deleting locationC"
go run containers_handler.go "delLocC" "$locationC"
# shellcheck disable=SC2035
rm locationB.csv locationC.csv