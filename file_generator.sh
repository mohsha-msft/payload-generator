#!/bin/bash
# shellcheck disable=SC2162
# Creates files.csv which contains file name, directory name, and size of the file
go run file_generator.go 1000 10 "/mnt/f/RandomData/base/"


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