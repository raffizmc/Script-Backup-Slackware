#/bin/bash


#######################################
# Script de Backup para Slackware
# Autor: R@fF1z-ft.dll
# link Github: https://github.com/rafF1z-ft
# Data: 02 de Agosto de 2022
#######################################


# Diretório de backup.
# Exemplo de uso para varios diretórios: /home/usuario/Documents /var/log /tmp
backup_path="/home/raffiz/Documents"

# Nao colocar barra no final, para nao ficar com dupla /.
# Aonde o backup será realizado.
external_storage="/mnt/backup_hd"

# Formato de arquivo.
date_format=$(date "+%d-%m-%y")
final_archive="backup-$date_format.tar.gz"

# Vai gerar um arquivo chamado "daily-backup.log"
# Log para ver a conclusão do procedimento.
log_file="/var/log/daily-backup.log"

########################################
## | VALIDAÇÕES | ##
########################################

# Verificando se o HD esta montado corretamente!
if ! mountpoint -q -- $external_storage; then
	printf "[$date_format][ERRO]HD não montado em $external_storage.\n" >> $log_file
	exit 1
fi

########################################

# Inicio do Backup
# Opções do tar : c = para criar o arquivo ; z = para compactar no formato gunzip(.gz) 
# S = Verificação inteligente(nao fazer backup de arquvos vazi) : p = preserva permisões de arquivos : f = final sempre, para indicar o arquivo.
# Primeiro ele vai localizar onde o arquivo vai ser salvo e depois qual arquivo ele vai salvar.
# Vai gerar uma mensa
printf "\n ### Compactando arquivos ### \n"
if tar czSpf "$external_storage/$final_archive" "$backup_path"; then
	printf "[$date_format] Backup feito com SUCESSO!\n" >> $log_file
else
	printf "[$date_format] Backup não realizado!\n" >> $log_file
fi

# Excluir arquivos que tiverem X tempo.
# Arquivos maiores(-time +) serao apagados!
find $external_storage -mtime +90
