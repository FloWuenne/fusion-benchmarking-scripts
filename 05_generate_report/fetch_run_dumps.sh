#!/bin/bash

# Function to display usage information
usage() {
    echo "Usage: $0 -u <url> -w <workspace> -f <id_file>"
    echo "  -u <url>        : Specify the Seqera Platform URL"
    echo "  -w <workspace>  : Specify the workspace on Seqera Platform"
    echo "  -f <id_file>    : Specify the file containing RunIDs (one per line)"
    exit 1
}

# Parse command-line options
while getopts "u:w:f:" opt; do
    case $opt in
        u) platform_url="$OPTARG" ;;
        w) workspace="$OPTARG" ;;
        f) id_file="$OPTARG" ;;
        *) usage ;;
    esac
done

# Check if all required parameters are provided
if [ -z "$platform_url" ] || [ -z "$workspace" ] || [ -z "$id_file" ]; then
    usage
fi

# Check if the ID file exists
if [ ! -f "$id_file" ]; then
    echo "Error: ID file '$id_file' not found."
    exit 1
fi

# Read IDs from the file and process each one
while IFS= read -r id || [[ -n "$id" ]]; do
    id=$(echo "$id" | tr -d '[:space:]')  # Remove any whitespace
    if [ -n "$id" ]; then
        output_file="${id}.tar.gz"
        echo "Fetching run dump for ID: $id"
        tw -u "$platform_url" runs dump -id "$id" -o "$output_file" -w "$workspace"
        echo "Dump saved as $output_file"
    fi
done < "$id_file"

echo "All run dumps have been fetched."