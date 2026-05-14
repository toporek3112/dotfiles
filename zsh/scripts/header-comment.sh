#!/bin/bash
# little script to create headers that I use

# Check if an input string was provided
if [ $# -eq 0 ]; then
    echo "No input string provided."
    exit 1
fi

# Input string from the first argument without extra spaces added
input_string="$1"

# Calculate the length of the input string plus the two spaces (one on each side)
input_length=$(( ${#input_string} + 2 ))

# Total width of the header
total_width=50

# Number of hashes before and after the input string
num_hashes=$(( (total_width - input_length) / 2 ))

# Print the top line of hashes
echo $(printf '%*s' $total_width | tr ' ' '#')

# Print the input string centered and surrounded by hashes, with spaces around the text
printf '%*s' $((num_hashes)) '' | tr ' ' '#'
printf ' %s ' "$input_string"
printf '%*s\n' $((num_hashes)) '' | tr ' ' '#'

# Print the bottom line of hashes
echo $(printf '%*s' $total_width | tr ' ' '#')
