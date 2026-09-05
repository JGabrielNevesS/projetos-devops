# Projetos DevOps

Repositório com pequenos projetos e scripts para aprendizado prático de tarefas comuns de DevOps (inspirado pelo Roadmap.sh).

Sumário
- [dummy-service](dummy-service/README.md) — exemplo de serviço systemd
- [log-archive](log-archive/README.md) — compacta logs em `~/archives`
- [nginx-log-analyzer](nginx-log-analyzer/README.md) — analisador de logs (sh + Python)
- [server-stats](server-stats/README.md) — coletor de métricas básicas do servidor
- [ansible/ansible-server-setup](ansible/ansible-server-setup/README.md) — playbooks e roles para setup de servidores
- [terraform](terraform/) — exemplos de configuração Terraform

Pré-requisitos
- Bash
- Python 3.8+ (apenas para `nginx-log-analyzer.py`)
- `tar`, `awk`, `sort`, `uniq`, `ps`, `df`, `top` (ferramentas padrão GNU)
- systemd (opcional, para `dummy-service`)

Contribuição
- Abra uma issue ou PR com melhorias, exemplos, ou testes.

Licença
- MIT

