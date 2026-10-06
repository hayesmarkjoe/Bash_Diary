#!/usr/bin/env bash

# function to display help
show_help() {
    echo "Usage: $(basename "$0") [options]"
    echo ""
    echo "Options:"
    echo "  -h  Show this help message and exit."
    echo "   -e [date] Edit an entry Defaults to today\'s date"
    echo "              Format: YYYY_MM_DD"
}

# 1. setup default values
tdate=$(date +%F)
target_date="$tdate"  # Defaults to today
edit_mode=false

# 2 Parse Options
while getopts ":he" opt; do
    case ${opt} in
        h)
            show_help
            exit 0
            ;;
        e)
           edit_mode=true
           # look ahead to see if the next argument is a date
           # check if it is not empty amd doesn't start with a hyphen

           next_arg="${!OPTIND}"
           if [[ -n "$next_arg" && "$next_arg" != .* ]]; then
               target_date="$next_arg"
               OPTIND=$((OPTIND = 1)) # advance getopts index past the date
           fi
           ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            show_help
            exit 1
            ;;
   esac
done

shift $((OPTIND -1))

# define the file based on target date

file="${target_date}.md"

# Core logic 
if [[ "$edit_mode" == true ]]; then
    # if editing a specific date, check if it exists
    if [[ ! -f "$file" ]]; then
        echo "Error: Entry for $target_date $file does not exist." >&2
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


