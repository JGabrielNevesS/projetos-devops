#!/usr/bin/env bash
set -Eeuo pipefail
umask 077

die() { printf 'Erro: %s\n' "$*" >&2; exit 1; }
usage() { printf 'Uso: %s [--dry-run] [--config ARQUIVO]\n' "$0"; }

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
CONFIG="$SCRIPT_DIR/backup.conf"
DRY_RUN=false
while (($#)); do
    case "$1" in
        --dry-run) DRY_RUN=true; shift ;;
        --config) (($# >= 2)) || die '--config exige um arquivo'; CONFIG=$2; shift 2 ;;
        -h|--help) usage; exit 0 ;;
        *) usage >&2; die "Opção desconhecida: $1" ;;
    esac
done

[[ -f "$CONFIG" ]] || die "Crie $CONFIG usando backup.conf.example como modelo."
# A configuração é código Bash: use somente arquivos de sua confiança.
source "$CONFIG"
: "${REMOTE_HOST:?Defina REMOTE_HOST na configuração}"
: "${REMOTE_USER:?Defina REMOTE_USER na configuração}"
: "${REMOTE_DIR:?Defina REMOTE_DIR na configuração}"
SSH_PORT=${SSH_PORT:-22}
SSH_KEY=${SSH_KEY:-}
[[ "$REMOTE_HOST" =~ ^[a-zA-Z0-9][a-zA-Z0-9.-]*$ ]] || die 'Host inválido; use IPv4, nome DNS ou alias SSH.'
[[ "$REMOTE_USER" =~ ^[a-zA-Z0-9_][a-zA-Z0-9_.-]*$ ]] || die 'Usuário SSH inválido.'
[[ "$SSH_PORT" =~ ^[0-9]+$ ]] && ((${#SSH_PORT} <= 5)) && ((10#$SSH_PORT >= 1 && 10#$SSH_PORT <= 65535)) || die 'Porta SSH inválida.'
# Restringir o caminho evita interpretação de comandos pelo shell remoto.
[[ "$REMOTE_DIR" =~ ^/[a-zA-Z0-9_./-]+$ && "$REMOTE_DIR" != / ]] || die 'Destino deve ser absoluto, diferente de / e sem espaços ou caracteres especiais.'
declare -p SOURCES 2>/dev/null | command grep -q '^declare -a ' || die 'Defina SOURCES como um array Bash.'
((${#SOURCES[@]})) || die 'SOURCES está vazio.'
for cmd in rsync ssh flock mktemp; do
    command -v "$cmd" >/dev/null || die "Dependência ausente: $cmd (veja README.md)."
done

STATE_DIR=${XDG_STATE_HOME:-"$HOME/.local/state"}/home-backup
mkdir -p -- "$STATE_DIR"
exec 9>"$STATE_DIR/backup.lock"
flock -n 9 || die 'Já existe outro backup em execução.'
FILE_LIST=$(mktemp)
trap 'rm -f -- "$FILE_LIST"' EXIT
for item in "${SOURCES[@]}"; do
    [[ -n "$item" && "$item" != /* && "$item" != . && "$item" != .. && "$item" != ../* && "$item" != */../* && "$item" != */.. ]] || die "Origem deve ser relativa à home, sem '..': $item"
    [[ -e "$HOME/$item" || -L "$HOME/$item" ]] || die "Origem não encontrada: $HOME/$item"
    printf '%s\0' "$item" >> "$FILE_LIST"
done

SSH_ARGS=(-p "$SSH_PORT" -o BatchMode=yes -o ConnectTimeout=15)
if [[ -n "$SSH_KEY" ]]; then
    [[ -f "$SSH_KEY" ]] || die "Chave SSH não encontrada: $SSH_KEY"
    SSH_ARGS+=(-i "$SSH_KEY" -o IdentitiesOnly=yes)
fi
printf -v SSH_COMMAND '%q ' ssh "${SSH_ARGS[@]}"
TARGET="$REMOTE_USER@$REMOTE_HOST"
if ! "$DRY_RUN"; then
    ssh "${SSH_ARGS[@]}" "$TARGET" "umask 077; mkdir -p -- '$REMOTE_DIR'"
fi
RSYNC_ARGS=(-a --no-owner --no-group --recursive --relative --from0
    --files-from="$FILE_LIST" --protect-args --itemize-changes --stats
    -e "$SSH_COMMAND")
"$DRY_RUN" && RSYNC_ARGS+=(--dry-run)
printf 'Backup: %s -> %s:%s\n' "$HOME" "$TARGET" "$REMOTE_DIR"
rsync "${RSYNC_ARGS[@]}" -- "$HOME/" "$TARGET:${REMOTE_DIR%/}/"
printf 'Concluído%s.\n' "$("$DRY_RUN" && printf ' (simulação)' || true)"
