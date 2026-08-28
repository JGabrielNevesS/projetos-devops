# nginx-log-analyzer

Ferramentas (Bash e Python) para análise simples de logs do Nginx.

Pré-requisitos
- `awk`, `sort`, `uniq` (para a versão em shell)
- Python 3 (para a versão em Python) — depende apenas da stdlib

Uso (Python)

```bash
python3 nginx-log-analyzer.py <arquivo-de-log>
```

Uso (Shell)

```bash
./nginx-log-analyzer.sh <arquivo-de-log>
```

O que analisa
- Top 5 IPs com mais requisições
- Top 5 paths mais requisitados
- Top 5 códigos de resposta
- Top 5 User-Agents

Notas
- Ajuste `LC_ALL` e encoding se necessário para logs com caracteres especiais.
