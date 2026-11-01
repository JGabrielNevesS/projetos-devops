# Permissão de escrita no volume de backup do LXC

## Ambiente

- Host: Proxmox VE.
- Container: 103, hostname `backup`, Debian não privilegiado.
- IP: `192.168.18.103`.
- Usuário do backup: `bkpjoao`, UID e GID `1000` no container.
- Bind mount: `/mnt/backups/computadores` no host → `/srv/backups` no container.

## Sintoma

Dentro do container, `/srv/backups` aparecia com proprietário `nobody:nogroup`.
Mesmo como root, alterar o dono falhava:

```text
chown bkpjoao:bkpjoao /srv/backups
chown: changing ownership of '/srv/backups': Operation not permitted
```

## Diagnóstico

Comandos executados no Shell do host Proxmox:

```bash
pct exec 103 -- id bkpjoao
pct exec 103 -- cat /proc/self/uid_map
pct exec 103 -- cat /proc/self/gid_map
```

Resultados relevantes:

```text
uid=1000(bkpjoao) gid=1000(bkpjoao)
         0     100000      65536
```

O mapeamento era igual para UID e GID: os IDs de 0 a 65535 no container correspondiam aos IDs de 100000 a 165535 no host.

| Identidade no container | ID no container | ID correspondente no host |
| --- | ---: | ---: |
| root | 0 | 100000 |
| bkpjoao | 1000 | 101000 |

O root de um LXC não privilegiado não equivale ao root do host. O proprietário do diretório montado não estava mapeado para um usuário do container, aparecendo como `nobody:nogroup`. A correção precisava ser feita pelo host.

## Correção

No **Shell do host Proxmox**:

```bash
chown 101000:101000 /mnt/backups/computadores
```

Foi alterado apenas o dono do diretório, sem alteração recursiva dos arquivos existentes. Não foi necessário tornar o container privilegiado nem liberar escrita para todos.

## Validação

No **Shell do host Proxmox**:

```bash
pct exec 103 -- ls -ld /srv/backups
pct exec 103 -- runuser -u bkpjoao -- sh -c 'touch /srv/backups/.teste-escrita && rm /srv/backups/.teste-escrita'
```

Critérios de sucesso: proprietário exibido como `bkpjoao:bkpjoao` dentro do container e criação/remoção do arquivo de teste sem erro. Após o ajuste, o usuário confirmou que funcionou. A conclusão do backup e a restauração dos dados ainda precisam ser verificadas separadamente.

## Para repetir em outro container

Confira sempre o UID/GID do usuário e os mapas reais antes de executar `chown`. O valor `101000` vale para o mapeamento observado neste container; não deve ser copiado automaticamente para outro ambiente.
