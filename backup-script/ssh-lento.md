## SSH demorando 25 segundos no LXC de backup

### Ambiente
- Container: 103 — backup
- Sistema: Debian, LXC não privilegiado
- IP: 192.168.18.103

### Sintoma
Conexões SSH demoravam aproximadamente 25 segundos.
O ping respondia normalmente, em cerca de 1 ms.
O atraso também ocorria ao executar um comando remoto:

    time ssh bkpjoao@192.168.18.103 'echo conectado'

Tempo medido: 25,277 segundos.

### Diagnóstico
Dentro do container, como root:

    systemctl status systemd-logind --no-pager -l
    journalctl -b -u ssh -u systemd-logind --since "10 minutes ago" --no-pager

Os logs mostraram:

    Failed at step NAMESPACE: Permission denied
    pam_systemd: Failed to create session
    service_start_timeout=25000ms

O systemd-logind não conseguia iniciar por uma restrição de
namespaces. O SSH aguardava o timeout antes de liberar a sessão.

No host Proxmox, `pct config 103` mostrou que o container
estava sem nesting habilitado.

### Correção
No Shell do host Proxmox, com interrupção do container:

    pct shutdown 103
    pct set 103 --features nesting=1
    pct start 103

### Validação
Repetido o teste de SSH após iniciar o container.
A conexão passou a ser imediata, sem a espera de 25 segundos.