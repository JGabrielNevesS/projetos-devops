# Projetos DevOps

Repositório com pequenos projetos e scripts para aprendizado prático de tarefas comuns de DevOps (inspirado pelo Roadmap.sh).

Sumário
- [dummy-service](dummy-service/README.md) — exemplo de serviço systemd
- [log-archive](log-archive/README.md) — compacta logs em `~/archives`
- [nginx-log-analyzer](nginx-log-analyzer/README.md) — analisador de logs (sh + Python)
- [server-stats](server-stats/README.md) — coletor de métricas básicas do servidor
- [logs](logs/) — exemplos de logs

Pré-requisitos
- Bash
- Python 3.8+ (apenas para `nginx-log-analyzer.py`)
- `tar`, `awk`, `sort`, `uniq`, `ps`, `df`, `top` (ferramentas padrão GNU)
- systemd (opcional, para `dummy-service`)

Instalação rápida

```bash
# torne scripts executáveis
chmod -R +x dummy-service nginx-log-analyzer log-archive server-stats
```

Instalar unidade systemd (opcional)

```bash
# copie a unit e atualize o systemd; ajuste o ExecStart no arquivo se necessário
sudo cp dummy-service/dummy.service /etc/systemd/system/
sudo sed -i 's|/usr/bin/dummy.sh|/caminho/para/seu/repo/dummy-service/dummy.sh|' /etc/systemd/system/dummy.service
sudo systemctl daemon-reload
sudo systemctl enable --now dummy.service
sudo journalctl -u dummy.service -f
```

Como usar

- Consulte o README de cada subprojeto para exemplos e flags:
  - [dummy-service/README.md](dummy-service/README.md)
  - [log-archive/README.md](log-archive/README.md)
  - [nginx-log-analyzer/README.md](nginx-log-analyzer/README.md)
  - [server-stats/README.md](server-stats/README.md)

Exemplo rápido (analisador de Nginx):

```bash
python3 nginx-log-analyzer/nginx-log-analyzer.py logs/access.log
```

Próximos passos sugeridos
- Adicionar `requirements.txt` se adicionarmos dependências Python
- Gerar exemplos de logs em `logs/` para testes automatizados
- Integração contínua básica (GitHub Actions): rodar lint e testes de scripts

Contribuição
- Abra uma issue ou PR com melhorias, exemplos, ou testes.

Licença
- MIT

