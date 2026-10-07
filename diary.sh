#!/usr/bin/env bash

# function to display help
show_help() {
    echo "Usage: $(basename "$0") [options]"
    echo ""
    echo "Options:"
    echo "  -h  Show this help message and exit."
    echo "   -e [date] Edit an entry Defaults to today\'s date"
    echo "              Format: YYYY-MM-DD"
}

# 1. setup default values
tdate=$(date +%F)
target_date="$tdate"  # Defaults to today
edit_mode=false

# 2 Parse Options
while getopts ":he:" opt; do
    case ${opt} in
        h)
            show_help
            exit 0
            ;;
        e)
           edit_mode=true
            target_date="$OPTARG"
           ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            show_help
            exit 1
            ;;
        :)
            # if -w wth no date, getopts triggers this
            # defdaults to editing today's post
            edit_mode=true
            target_date="$tdate"
            ;;
   esac
done

shift $((OPTIND -1))
# clean up extensions if typed YYYY-DD-MM.md -> YYYY-DD-MM
if [[ $"target_date" = "today" ]]; then
    target_date="$tdate"
fi

# define the file based on target date
clean_date="${target_date%.md}"
file="${clean_date}.md"

# Core logic 
if [[ "$edit_mode" == true ]]; then
    # if editing a specific date, check if it exists
    if [[ ! -f "$file" ]]; then
        echo "Error: Entry for $clean_date $file does not exist." >&2
        exit 1
    fi
    ${EDITOR} "${file}"
else
    if [[ ! -f "$file" ]]; then
        touch "$file"
        read -p "Enter a title for todays entry: " title
        printf "**%s%s**\n" "[${tdate}]    ${title}" >> "$file"
        $EDITOR "$file" 
    else
        $EDITOR "$file"
    fi
fi
