# server-stats

Scripts simples para coletar estatísticas do servidor (CPU, memória, disco e processos).

Pré-requisitos
- `top`, `free`, `df`, `ps`

Uso

```bash
./server-stats.sh
```

Saída
- Uso total de CPU
- Memória usada/total e percentual
- Estatísticas de disco (total/usado/livre)
- Top 5 processos por CPU e por memória
