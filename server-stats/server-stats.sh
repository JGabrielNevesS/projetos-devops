#! /usr/bin/bash

total_cpu_usage() {
    LC_ALL=C top -bn2 -d 1 | awk '/^%Cpu\(s\):/ { uso = 100 - $8 } END { printf "Uso de CPU: %.1f%%\n", uso }'
}

memory_stats() {
    free -k | awk '/^Mem/ {printf "Memória: %.2f / %.2f GiB (%.1f%%)\n", $3 / 1048576, $2 / 1048576, $3 / $2 * 100}'
}

disk_stats() {
    df -h --total | grep total | awk '{print "Disco:\nTotal: " $2 "\nUsado: " $3 "\nLivre: " $4 "\nUso: " $5}'
}

get_top_cpu() {
    echo "Top 5 processos por uso de CPU"
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -6
}

get_top_memory() {
    echo "Top 5 processos por uso de memória"
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -6
}

main() {
    total_cpu_usage
    memory_stats
    disk_stats
    get_top_cpu
    get_top_memory
}

main