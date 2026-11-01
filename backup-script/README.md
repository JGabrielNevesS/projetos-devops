# Backup da home para uma VM

Script Bash para Debian e Fedora, usando rsync sobre SSH. Copia as origens
selecionadas e mantém a estrutura relativa à home. Não apaga arquivos no destino.
Arquivos modificados substituem a cópia anterior: este script não mantém versões.
Links simbólicos são copiados como links, sem copiar o conteúdo externo apontado.

## Preparação

No Debian, instale no computador e na VM:

```sh
sudo apt install rsync openssh-client
```

No Fedora:

```sh
sudo dnf install rsync openssh-clients
```

A VM também precisa ter um servidor SSH ativo (`openssh-server`) e o usuário
remoto precisa poder escrever na pasta de destino. O computador precisa de
`flock`, normalmente fornecido pelo pacote `util-linux`.

Configure o acesso por chave SSH e faça uma primeira conexão manual para verificar
a identidade do servidor. Exemplo (ajuste usuário, endereço e porta):

```sh
ssh-keygen -t ed25519
ssh-copy-id -p 22 joao@192.168.1.100
ssh -p 22 joao@192.168.1.100
```

Se já tiver uma chave, use a existente. Para chaves protegidas por senha, carregue
a chave no agente SSH antes de executar: o script usa `BatchMode` e não pede senha.

## Uso

```sh
cp backup.conf.example backup.conf
chmod 600 backup.conf
```

Edite `backup.conf` com a conexão da VM, um destino absoluto e as pastas desejadas.
O exemplo seleciona apenas `Documentos`. Se fizer backup de dois computadores,
use um destino diferente para cada um, como `/home/joao/backups/debian` e
`/home/joao/backups/fedora`, para evitar que seus arquivos se sobrescrevam.
O destino aceita letras, números, pontos, barras, hífens e sublinhados; as origens
podem conter espaços. Não use `~` no destino. A configuração é executada como Bash;
use apenas um arquivo de sua confiança.

```sh
bash backup.sh --dry-run
bash backup.sh
```

A simulação conecta à VM, mas não cria a pasta nem copia arquivos. Se o destino
ainda não existir, crie-o via SSH antes da simulação, ou execute o backup real
para que o script o crie. Para outra configuração, use `--config /caminho/arquivo`.

Erros interrompem a execução e retornam status diferente de zero. Uma trava impede
execuções simultâneas pelo mesmo usuário neste computador. Dados em uso podem
mudar durante a cópia; feche aplicativos relevantes antes do backup, especialmente
bancos de dados. Arquivos já enviados podem permanecer se a conexão for interrompida.

## Recuperação

Exemplo para recuperar Documentos em uma pasta separada e conferir o conteúdo:

```sh
mkdir -p "$HOME/recuperado"
rsync -av -e 'ssh -p 22' joao@192.168.1.100:/home/joao/backups/meu-computador/Documentos/ "$HOME/recuperado/Documentos/"
```

Faça uma recuperação de teste após o primeiro backup. Permissões de proprietário,
ACLs e atributos estendidos não são preservados por este script.
