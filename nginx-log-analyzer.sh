#!/usr/bin/env bash

ngixn-analyser() {
    local file="${1:-}"

    echo "Top 5 IP addresses with the most requests:"
    awk '{print $1}' "$file" | sort | uniq -c | sort -nr | head -5 | awk '{printf "%s - %s requests\n", $2, $1}'

    echo ""
    echo "Top 5 most requested paths:"
    awk '{print $7}' "$file" | sort | uniq -c | sort -nr | head -5 | awk '{printf "%s - %s requests\n", $2, $1}'

    echo ""
    echo "Top 5 response status codes:"
    
    awk -F'"' '{split($3, response, " "); print response[1]}' "$file" | sort | uniq -c | sort -nr | head -n 5 | awk '{printf "%s - %s requests\n", $2, $1}'

    echo ""
    echo "Top 5 user agents:"
    awk -F'"' '{print $6}' "$file" | sort | uniq -c | sort -nr | head -5 | awk '{printf "%s - %s requests\n", $2, $1}'

}

ngixn-analyser $1