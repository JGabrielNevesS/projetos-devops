#!/usr/bin/env bash

log_archive() {
    local dir="${1:-}"
    local date_time
    local save_dir="$HOME/archives"

    date_time=$(date +%Y%m%d_%H%M%S)

    if [[ -z "$dir" ]]; then
        echo "Uso: $0 <arquivo-ou-diretório>"
        return 1
    fi

    if [[ ! -e "$dir" ]]; then
        echo "Erro: caminho não encontrado: $dir"
        return 1
    fi

    echo "Compactando logs: $dir"
    
    if ! mkdir -p "$save_dir"; then
        echo "Erro ao criar diretório: $save_dir"
        return 1
    fi
    
    if tar -czvf $save_dir/logs_archive_${date_time}.tar.gz "$dir"; then
        echo "Arquivo de log compactado com sucesso e salvo em $save_dir"
    else
        echo "Erro ao compactar arquivo!"
        return 1
    fi
}

log_archive "$1"