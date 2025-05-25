#!/usr/bin/env bash

##########################################################################
# Script Backups
# Autor: R4fF1z.pwn
# Github: https://github.com/raffizmc/Script-Backup-Slackware
# Data: 25/05/2025
versao="Versão: 4.3"
##########################################################################

# VARIÁVEIS
data_atual=$(date "+%d-%m-%y")
arquivo_final="backup-$data_atual.tar.gz"
diretorio_tmp="/tmp/backup"
log_backup="/var/log/backup/backup_diario.log"
servidor_destino="usuario-server@ip-server"
porta_ssh="porta-server"        # Padrão é 22
destino_server="/mnt/backup"

# GARANTE QUE DIRETÓRIOS EXISTAM
[ ! -d "$diretorio_tmp" ] && mkdir -p "$diretorio_tmp" && echo "[INFO] Criado diretório temporário: $diretorio_tmp"
[ ! -d "$(dirname "$log_backup")" ] && mkdir -p "$(dirname "$log_backup")" && echo "[INFO] Criado diretório de log: $(dirname "$log_backup")"

# GERA LISTA DE PACOTES INSTALADOS
yay -Qq > "$diretorio_tmp/packages" || {
    echo "[ $(date) ] Erro ao gerar lista de pacotes." >> "$log_backup"
    exit 1
}

# COMPACTA BACKUP
tar -czpf "$diretorio_tmp/$arquivo_final" \
  --absolute-names \
  --preserve-permissions \
  --warning=no-file-changed \
  /home/usuario/Documentos \        # Exemplo de arquivos, nao pode haver este comentario no script final
  /home/usuario/.ssh \
  "$diretorio_tmp/packages"

if [ $? -ne 0 ]; then
    echo "[ $(date) ] Erro ao criar backup local!" >> "$log_backup"
    exit 1
fi

# ENVIA PARA O SERVIDOR
scp -P "$porta_ssh" "$diretorio_tmp/$arquivo_final" "$servidor_destino:$destino_server"
if [ $? -ne 0 ]; then
    echo "[ $(date) ] Falha ao enviar backup para o servidor!" >> "$log_backup"
    exit 1
fi

# LIMPA BACKUPS ANTIGOS NO SERVIDOR (mantém os 5 mais recentes)
ssh -p "$porta_ssh" "$servidor_destino" "cd '$destino_server' && ls -tp backup-*.tar.gz | grep -v '/$' | tail -n +6 | xargs -r rm --"

# LOG FINAL
echo "[ $(date) ] Backup realizado e enviado com sucesso! ✅" >> "$log_backup"

# MOSTRA ÚLTIMA LINHA DO LOG
tail -n 1 "$log_backup"
