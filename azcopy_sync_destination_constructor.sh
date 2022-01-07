#!/bin/bash
set -e
path="/mnt/f/RandomData/base"
sas_validity_in_hrs=24
version="10.13.0"
operation="copy"
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
location0=$path/source
locationA="$path/selected/"
mkdir -p $locationA
itr=0

walk_dir () {
    shopt -s nullglob dotglob

    for pathname in "$1"/*; do
        if [ -d "$pathname" ]; then
            walk_dir "$pathname"
        else
            ((itr=itr+1))
            echo "$path $locationA $itr"
            remainder=$(( itr % 3 ))
            if [ "$remainder" -eq 0 ]; then
                cp $pathname $locationA
            fi
        fi
    done
}

walk_dir "$location0"

go run containers_handler.go "locB" "$locationA" "$sas_validity_in_hrs" "$version"
locationB=$( tail -n 1 locationB$version.csv )
bash run_azcopy.sh -o "$operation" -v "$version" -s "$locationA" -d "$locationB" > sync_destination_construction/upload_$taskId.txt
echo "Created Location B: $locationB"

go run containers_handler.go "locC" "$locationB" "$sas_validity_in_hrs" "$version"
locationC=$( tail -n 1 locationC$version.csv )
bash run_azcopy.sh -o "$operation" -v "$version" -s "$locationB" -d "$locationC" > sync_destination_construction/s2s_$taskId.txt
echo "Created Location C: $locationC"

locationD="$path/destination/"
mkdir -p "$locationD"
cp -R $path/source/* $locationD
echo "Created Location D: $locationD"