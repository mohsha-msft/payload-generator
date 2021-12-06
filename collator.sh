#!/bin/bash
number_of_files=100
number_of_entities_per_level=10
path="/mnt/f/RandomData/base"
sas_validity_in_hrs=24

#while getopts n:e:p: flag
#do
#    case "${flag}" in
#        n) number_of_files=${OPTARG};;
#        e) number_of_entities_per_level=${OPTARG};;
#        p) path=${OPTARG};;
#        *)
#            echo "Invalid flag";
#                  exit 1;
#              ;;
#    esac
#done

sh local_file_generator.sh -n "$number_of_files" -e "$number_of_entities_per_level" -p "$path/source/"

# A (Local) --- upload ---> B (Container1) ---- S2S ---> C (container2) --- Download ---> D (Local)

# Run Upload Test

# Create destination -> Location.csv will contain source and destination
go run containers_handler.go "locB" "$path/source/" "$sas_validity_in_hrs"


# Run S2S Test
locationB=$( tail -n 1 locationB.csv )

go run containers_handler.go "locC" "$locationB" "$sas_validity_in_hrs"

# Run Download Test


# Perform cleanup

# delete A->B->C->D

# shellcheck disable=SC2035
#rm -rf *.csv