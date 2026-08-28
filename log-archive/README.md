# log-archive

Script para arquivar/compactar arquivos e diretórios de logs.

Pré-requisitos
- Bash
- `tar`, `realpath`

Uso

```bash
./log-archive.sh <arquivo-ou-diretório> [outros caminhos...]
```

Exemplo

```bash
./log-archive.sh logs/access.log logs/error.log
# cria $HOME/archives/logs_archive_YYYYMMDD_HHMMSS.tar.gz
```

Comportamento
- Valida se os caminhos existem.
- Compacta os itens informados em `~/archives` com timestamp.
