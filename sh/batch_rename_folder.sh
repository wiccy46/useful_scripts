#!/bin/bash

# From ChatGPT
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <main_folder> <old_folder_name> <new_folder_name>"
    exit 1
fi

main_folder=$1
old_name=$2
new_name=$3

if [ ! -d "$main_folder" ]; then
    echo "Main folder '$main_folder' does not exist."
    exit 1
fi

find "$main_folder" -type d -name "$old_name" -exec sh -c '
    for dir; do
        newdir=$(dirname "$dir")/'"$new_name"'
        echo "Renaming $dir to $newdir"
        mv "$dir" "$newdir"
    done
' sh {} +

echo "Folder renaming completed."

