#!/bin/bash
path="/mnt/f/RandomData/anotherbase"
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