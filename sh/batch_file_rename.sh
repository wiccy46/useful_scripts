#!/bin/bash

show_usage() {
    echo "Usage: $0 <main_folder> <extension> <old_substring> <new_substring>"
    echo "       $0 -h"
    echo
    echo "Arguments:"
    echo "  <main_folder>    The directory in which files are to be renamed."
    echo "  <extension>      The file extension to filter files by."
    echo "  <old_substring>  The substring to be replaced in file names."
    echo "  <new_substring>  The new substring to replace the old one."
    echo
    echo "Options:"
    echo "  -h               Display this help message and exit."
}

if [ "$1" == "-h" ]; then
    show_usage
    exit 0
fi

if [ "$#" -ne 4 ]; then
    show_usage
    exit 1
fi

main_folder=$1
extension=$2
old_substring=$3
new_substring=$4

if [ ! -d "$main_folder" ]; then
    echo "Main folder '$main_folder' does not exist."
    exit 1
fi

delete_existing=unset

find "$main_folder" -type f -name "*.$extension" | while read file; do
    # Extract directory path and file name
    dir=$(dirname "$file")
    base_name=$(basename "$file")

    if [[ "$base_name" == *"$old_substring"* ]]; then
        new_name=${base_name//$old_substring/$new_substring}
        new_path="$dir/$new_name"

        if [ -e "$new_path" ]; then
            if [ "$delete_existing" == "unset" ]; then
                read -p "File '$new_path' already exists. Delete it? [y/n/all/none]: " choice
                case $choice in
                    y) rm -rf "$new_path";;
                    all) delete_existing=yes;;
                    none) delete_existing=no;;
                    *) echo "Operation aborted."; exit 1;;
                esac
            fi

            if [ "$delete_existing" == "yes" ]; then
                rm -rf "$new_path"
            elif [ "$delete_existing" == "no" ]; then
                continue
            fi
        fi

        echo "Renaming $file to $new_path"
        mv "$file" "$new_path"
    fi
done

echo "File renaming completed."

