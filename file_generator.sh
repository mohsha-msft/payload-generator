#!/bin/bash
# shellcheck disable=SC2162

while IFS="," read -r Name Parent Size
do
  mkdir -p "$Parent"
  FileName="$Parent$Name"
  case $Size in
    "1K" | "10K" | "100K" | "1M" | "10M")
      dd if=/dev/urandom of="$FileName" bs="$Size" count=1
      ;;
    "100M")
      dd if=/dev/urandom of="$FileName" bs="32M" count=3
      ;;
    "1G")
      dd if=/dev/urandom of="$FileName" bs="64M" count=16
      ;;
    "10G")
      dd if=/dev/urandom of="$FileName" bs="64M" count=160
      ;;
  esac
done < files.csv