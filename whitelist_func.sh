#!/bin/bash

is_whitelisted() {
    local file="$1"
    local filename
    local extension
    local whitelist_entry
    local w_filename
    local w_extension

    filename=$(basename "$file")
    extension=${filename##*.}
    extension=".$extension"

    if [ ! -f "$whitelist" ]
    then
        return 1
    fi

    while IFS= read -r whitelist_entry
    do
        w_filename=$(basename "$whitelist_entry")
        w_extension=${w_filename##*.}
        w_extension=".$w_extension"

        if [ "$filename" = "$w_filename" ] && [ "$extension" = "$w_extension" ]
        then
            return 0
        fi
    done < "$whitelist"

    return 1
}
