#!/usr/bin/env bash

validate_dir() {
    local dir="${1:-}"
    if [[ -z "$dir" ]]; then
        echo "Uso: $0 <arquivo-ou-diretório>"
        return 1
    fi

    if [[ ! -e "$dir" ]]; then
        echo "Erro: caminho não encontrado: $dir"
        return 1
    fi
}

log_archive() {
    local date_time
    local save_dir="$HOME/archives"

    date_time=$(date +%Y%m%d_%H%M%S)

    if [[ $# -eq 0 ]]; then
        echo "Nenhum arquivo recebido"
        return 1
    fi

    for dir in $@; do 
        if ! validate_dir "$dir" ; then return 1; fi
    done

    echo "Compactando logs"
    
    if ! mkdir -p "$save_dir"; then
        echo "Erro ao criar diretório: $save_dir"
        return 1
    fi
    
    if tar -czvf $save_dir/logs_archive_${date_time}.tar.gz "$@"; then
        echo "Arquivo de log compactado com sucesso e salvo em $save_dir"
    else
        echo "Erro ao compactar arquivo!"
        return 1
    fi
}

log_archive "$@"