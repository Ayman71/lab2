#!/bin/bash

if [ "$#" -ne 3]
then
    echo "Error: $0 dir malicious_dir interval_secs"
    exit 1
fi

dir="$1"
malicious_dir="$2"
interval="$3"

if [ ! -d "$dir" ]
then
    echo "Error: source directory does not exist"
    exit 1
fi

if ! [[ "$interval" =~ ^[1-9][0-9]*$ ]]
then
    echo "Error: interval must be a positive integer"
    exit 1
fi

mkdir -p "$malicious_dir"

flagged_extensions=(
    ".exe"
    ".bat"
    ".vbs"
    ".scr"
    ".ps1"
)

flagged_keywords=(
    "virus"
    "trojan"
    "malware"
    "worm"
    "ransomware"
)

last_snap="directory_info.last"
new_snap="directory_info.new"

is_malicious(){
    local file="$1"
    local filename
    local extension
    local keyword

    filename=$(basename "$file")
    extension=${filename##*.}
    extension=".$extension"

    for ext in "${flagged_extensions[@]}"
    do
	if [ "$extension" = "$ext" ]
	then
	   return 0
        fi
    done

    for keyword in "${flagged_keywords[@]}"
    do
	if grep -q -i -F "$keyword" "$file" 2>/dev/null
	then
	    return 0
	fi
    done

    return 1
}


scan_directory() {

    local file
    local filename

    echo "The antivirus is scanning the directory $dir...."

    while IFS= read -r -d '' file
    do
	filename=$(basename "$file")
	if is_malicious "$file"
	then
	    echo "$file is malicious and it has been DELETED"
	    cp -- "$file" "malicious_dir/$filename"
	    rm -- "$file"
	fi
    done < <(find "$dir" -maxdepth 1 -type f -print0)
}

if [ ! -f "$last_snap" ]
then
    echo "First run: scanning...."
    scan_directory
else
    echo "Using last snapshot: $last_snap"
fi

while true
do
    sleep "$interval"
    ls -l "$dir" > "$new_snap"

    if cmp -s "$last_snap" "$new_snap"
    then
	echo "No changes detected"
    else
	echo "Change detected, scanning...."
	scan_directory
	cp -- "$new_snap" "$last_snap"
    fi
done


