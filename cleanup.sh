#!/bin/bash
# Perform cleanup
while getopts v: flag
do
    case "${flag}" in
        v) version=${OPTARG};;
        *)
            echo "Invalid flag";
                  exit 1;
              ;;
    esac
done

echo "Stating Cleanup ================================================================================================="
echo "Deleting locationB"
locationB=$( tail -n 1 locationB$version.csv )
go run containers_handler.go "delLocB" "$locationB"

echo "Deleting locationC"
locationC=$( tail -n 1 locationC$version.csv )
go run containers_handler.go "delLocC" "$locationC"
