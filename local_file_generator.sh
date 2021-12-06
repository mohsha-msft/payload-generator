#!/bin/bash
# shellcheck disable=SC2162
# Creates files.csv which contains file name, directory name, and size of the file

number_of_files=100
number_of_entities_per_level=10
path="/mnt/f/RandomData/base/source"

while getopts n:e:p: flag
do
    case "${flag}" in
        n) number_of_files=${OPTARG};;
        e) number_of_entities_per_level=${OPTARG};;
        p) path=${OPTARG};;
        *) echo "Invalid flag";
           exit 1;
           ;;
    esac
done

go run local_file_generator.go "$number_of_files" "$number_of_entities_per_level" "$path"

# Read the CSV file and construct the load
while IFS="," read -r Name Parent Size
do
  mkdir -p "$Parent"
  FileName="$Parent$Name"
  case $Size in
    "1K" | "10K" | "100K" | "1M" | "10M")
      dd if=/dev/urandom of="$FileName" bs="$Size" count=1 iflag=fullblock
      ;;
    "100M")
      dd if=/dev/urandom of="$FileName" bs="32M" count=3 iflag=fullblock
      ;;
    "1G")
      dd if=/dev/urandom of="$FileName" bs="64M" count=16 iflag=fullblock
      ;;
    "10G")
      dd if=/dev/urandom of="$FileName" bs="64M" count=160 iflag=fullblock
      ;;
  esac
done < files.csv