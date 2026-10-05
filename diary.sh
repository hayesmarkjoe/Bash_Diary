#!/usr/bin/env bash

tdate=$(date +%F)
file=${tdate}.md
    if [[ ! -f "$file" ]]; then
        touch "$file"
        read -p "Enter a title for todays entry: " title
        printf "**%s%s**\n" "[${tdate}]    ${title}" >> "$file"
        $EDITOR "$file" 
    else
        $EDITOR "$file"
    fi


