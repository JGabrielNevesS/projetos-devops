#!/usr/bin/env bash


addresses_requests() {
    local file="${1:-}"
    echo "Top 5 IP addresses with the most requests:"
    awk '{print $1}' "$file" | sort | uniq -c | sort -nr | head -5 | awk '{printf "%s - %s requests\n", $2, $1}'
}

most_requests() {
    echo ""
    echo "Top 5 most requested paths:"
    awk '{print $7}' "$file" | sort | uniq -c | sort -nr | head -5 | awk '{printf "%s - %s requests\n", $2, $1}'
}

response_status_code() {
    echo ""
    echo "Top 5 response status codes:"
    awk -F'"' '{split($3, response, " "); print response[1]}' "$file" | sort | uniq -c | sort -nr | head -n 5 | awk '{printf "%s - %s requests\n", $2, $1}'
}

user_agents() {
    echo ""
    echo "Top 5 user agents:"
    awk -F'"' '{print $6}' "$file" | sort | uniq -c | sort -nr | head -5 | awk '{printf "%s - %s requests\n", $2, $1}'
}

main() {
    local file="${1:-}"
    addresses_requests $file
    most_requests $file
    response_status_code $file
    user_agents $file
}

main $1