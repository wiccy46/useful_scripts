#!/bin/bash

show_usage() {
    echo "Usage: $0 <main_folder> <old_folder_name> <new_folder_name>"
    echo "       $0 -h"
    echo
    echo "Arguments:"
    echo "  <main_folder>      The directory in which folders are to be renamed."
    echo "  <old_folder_name>  The folder name to be replaced."
    echo "  <new_folder_name>  The new folder name."
    echo
    echo "Options:"
    echo "  -h                 Display this help message and exit."
}

if [ "$1" == "-h" ]; then
    show_usage
    exit 0
fi

if [ "$#" -ne 3 ]; then
    show_usage
    exit 1
fi

main_folder=$1
old_name=$2
new_name=$3

if [ ! -d "$main_folder" ]; then
    echo "Main folder '$main_folder' does not exist."
    exit 1
fi

handle_existing=unset

find "$main_folder" -type d -name "$old_name" -exec sh -c '
    for dir; do
        newdir=$(dirname "$dir")/'"$new_name"' 
        if [ -e "$newdir" ]; then
            if [ "$handle_existing" = "unset" ]; then
                echo "Folder $newdir already exists. Choose an option:"
                echo "  [y] Delete existing and rename"
                echo "  [n] Skip renaming this folder"
                echo "  [a] Apply 'delete' to all existing"
                echo "  [s] Skip all existing"
                read -r choice
                case $choice in
                    y) rm -rf "$newdir";;
                    n) continue;;
                    a) handle_existing="delete";;
                    s) handle_existing="skip";;
                    *) echo "Invalid choice. Exiting."; exit 1;;
                esac
            fi
            if [ "$handle_existing" = "delete" ]; then
                rm -rf "$newdir"
            elif [ "$handle_existing" = "skip" ]; then
                continue
            fi
        fi
        echo "Renaming $dir to $newdir"
        mv "$dir" "$newdir"
    done
' sh {} +

echo "Folder renaming completed."

