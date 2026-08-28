# dummy-service

Exemplo mínimo de serviço "dummy" que demonstra uma unidade systemd e um script simples.

Pré-requisitos
- systemd (para executar como serviço)
- permissões adequadas para gravar em `/var/log`

Instalação e uso

1. Torne o script executável:

```bash
chmod +x dummy.sh
```

2. Executar manualmente (para testes):

```bash
./dummy.sh
```

3. Para instalar como serviço systemd (exemplo):

```bash
sudo cp dummy.service /etc/systemd/system/
sudo sed -i 's|/usr/bin/dummy.sh|/caminho/para/seu/repo/dummy-service/dummy.sh|' /etc/systemd/system/dummy.service
sudo systemctl daemon-reload
sudo systemctl enable --now dummy.service
sudo journalctl -u dummy.service -f
```

Observações
- O `dummy.sh` escreve repetidamente em `/var/log/dummy-service.log`; use com cuidado em ambientes de produção.
