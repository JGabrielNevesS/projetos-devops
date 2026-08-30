# Ansible — Server Setup

Este diretório contém playbooks e roles para preparar e configurar servidores básicos.

Visão geral
- `inventory.ini` — inventário de exemplo usado pelos playbooks.
- `setup.yml` — playbook principal que aplica as roles em `roles/`.
- `roles/` — roles reutilizáveis: `app`, `base`, `nginx`, `ssh`.

Pré-requisitos
- Ansible 2.9+ instalado na máquina de controle.
- Acesso SSH às máquinas alvo (chave SSH ou senha).

Como usar
1. Ajuste `inventory.ini` com seus hosts e variáveis.
2. Execute o playbook (exemplo usando sudo):

```bash
ansible-playbook -i inventory.ini setup.yml --ask-become-pass
```

Se você usa chaves SSH e não precisa de senha de sudo, rode sem `--ask-become-pass`.

Testes de roles
Cada role tem uma pasta `tests/` com um inventário e um playbook de teste. Para testar uma role localmente:

```bash
ansible-playbook -i roles/<role>/tests/inventory roles/<role>/tests/test.yml
```

Estrutura das roles
- `defaults/main.yml` — valores padrão
- `vars/main.yml` — variáveis fixas da role
- `tasks/main.yml` — tarefas principais
- `handlers/main.yml` — handlers (ex.: reload services)
- `templates/` e `files/` — artefatos entregues aos hosts

Boas práticas
- Teste em VMs ou hosts de staging antes de aplicar em produção.
- Versione secrets fora do repositório (use Ansible Vault quando necessário).

Contribuindo
- Abra issues ou PRs para bugs e melhorias nas roles ou playbooks.
