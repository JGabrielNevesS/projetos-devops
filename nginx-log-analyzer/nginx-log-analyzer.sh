#!/usr/bin/env bash


addresses_requests() {
    local file="${1:-}"
    echo "Top 5 IP addresses with the most requests:"
    awk '{print $1}' "$file" | sort | uniq -c | sort -nr | head -5 | awk '{printf "%s - %s requests\n", $2, $1}'
}

most_requests() {
    echo ""
    echo "Top 5 most requested paths:"
    awk -F'"' '
        {
            request = $2
            parts = split(request, req, " ")

            if (parts == 3 && req[3] ~ /^HTTP\//) {
                print req[2]
            } else {
                malformed++
            }
        }
        END {
            print "Requisições inválidas:", malformed > "/dev/stderr"
        }
        ' "$file" | sort | uniq -c | sort -nr | head -5 | awk '{printf "%s - %s requests\n", $2, $1}'
}

response_status_code() {
    echo ""
    echo "Top 5 response status codes:"
    awk -F'"' '{split($3, response, " "); print response[1]}' "$file" | sort | uniq -c | sort -nr | head -n 5 | awk '{printf "%s - %s requests\n", $2, $1}'
}

user_agents() {
    echo ""
    
    awk -F'"' '{print $6}' "$file" | sort | uniq -c | sort -nr | head -5 | awk '{
        quantidade = $1
        $1 = ""
        sub(/^[[:space:]]+/, "")
        printf "%s - %s requests\n", $0, quantidade
    }'
}

main() {
    local file="${1:-}"
    addresses_requests $file
    most_requests $file
    response_status_code $file
    user_agents $file
}

main $1