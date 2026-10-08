#!/bin/bash

if [ "$#" -ne 2 ]
then
    echo "Error: $0 dir malicious_dir"
    exit 1
fi

dir="$1"
malicious_dir="$2"

whitelist="whitelist.txt"
source ./whitelist_func

if [ ! -d "$dir" ]
then
    echo "Error: source directory does not exist"
    exit 1
fi

if [ ! -d "$malicious_dir" ]
then
    echo "Error: malicious directory does not exist"
    exit 1
fi

while true
do
    mapfile -d '' files < <(
	find "$malicious_dir" -maxdepth 1 -type f -print0
    )

    count="${#files[@]}"

    if [ "$count" -eq 0 ]
    then
	echo "No malicious files to manage"
	exit 0
    fi

    echo "Files in quarantine"
    echo "-------------------"

    for ((i=0; i<count; i++))
    do
	echo "$((i + 1)). $(basename "${files[$i]}")"
    done

    echo
    read -r -p "Choose a file number: " choice

    if ! [[ "$choice" =~ ^[0-9]+$ ]]
    then
	echo "Invalid choice"
	continue
    fi

    index=$((choice - 1))

    if [ "$index" -lt 0 ] || [ "$index" -ge "$count" ]
    then
	echo "Invalid choice"
	continue
    fi

    selected_file="${files[$index]}"
    filename=$(basename "$selected_file")

    echo
    echo "Selected: $filename"
    echo "1. Restore"
    echo "2. Permanent delete"
    echo "3. Leave as-is"

    read -r -p "Choose an action: " action

    case "$action" in
	1)
	    touch "$whitelist"
	    if ! is_whitelisted "$selected_file"
            then
                echo "$filename" >> "$whitelist"
            fi

	    mv -- "$selected_file" "$dir/$filename"
	    echo "Restored $filename to $dir"
	    ;;
	2)
	    rm -- "$selected_file"
	    echo "$filename permanently deleted"
	    ;;
	3)
	    echo "Leaving $filename as-is"
	    ;;
	*)
	    echo "Invalid choice"
	    ;;
    esac
done

