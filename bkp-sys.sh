#!/usr/bin/env bash

#######################################
# Script de Backup para Slackware
# Autor: r4ff1z.dll
# link Github: https://github.com/raffizmc
# Data: 02 de Agosto de 2022
versao="Versão: ss4 2.5"
#######################################

#######################################
## | AJUDA | ##
#######################################

# Função para exibir mensagem de ajuda
exibir_ajuda(){
    echo "Uso: $0 [-c|-p] [-l caminho_completo]"
    echo "Opções:"
    echo "  -c             Realiza backup completo (/root, /tmp, /var/log, /home/usuario)"
    echo "  -p             Realiza backup personalizado"
    echo "  -l caminho     Localiza e monta o dispositivo externo (ex: /dev/sda1); Use 'lsblk' para localizar"
    echo "  -h             Exibe esta mensagem de ajuda"
    echo $versao
}

# Variáveis padrão
date_format=$(date "+%d-%m-%y")
final_archive="backup-$date_format.tar.gz"
log_file="/var/log/daily-backup.log"
dispositivo_local=""
tipo_backup=""

# Definir o local de armazenamento padrão
default_storage="/var/backup"
external_storage="$default_storage"

# Parse de argumentos
while getopts ":cpl:h" opt; do
    case ${opt} in
        c )
            tipo_backup="completo"
            ;;
        p )
            tipo_backup="personalizado"
            ;;
        l )
            dispositivo_local=$OPTARG
            external_storage="/mnt/backup_hd"
            ;;
        h )
            exibir_ajuda
            exit 0
            ;;
        \? )
            echo "Opção inválida: $OPTARG" 1>&2
            exibir_ajuda
            exit 1
            ;;
        : )
            echo "Opção $OPTARG requer um argumento." 1>&2
            exibir_ajuda
            exit 1
            ;;
    esac
done

# Verificar se tipo de backup foi fornecido
if [ -z "$tipo_backup" ]; then
    exibir_ajuda
    exit 1
fi

#########################################
## | MONTAGEM_E_FORMATO | ##
#########################################

# Se o dispositivo local foi especificado, tente montá-lo
if [ -n "$dispositivo_local" ]; then
    echo "Montando Dispositivo $dispositivo_local em $external_storage"
    sudo mkdir -p $external_storage
    if ! sudo mount $dispositivo_local $external_storage; then
        echo "Erro ao montar o dispositivo $dispositivo_local em $external_storage" >> $log_file
        exit 1
    fi

    # Verificando se o Dispositivo está montado corretamente!
    if ! mountpoint -q -- $external_storage; then
        printf "[$date_format][ERRO] Dispositivo não montado em $external_storage.\n" >> $log_file
        exit 1
    fi
fi

# Certifique-se de que o diretório de armazenamento padrão existe
if [ ! -d "$default_storage" ]; then
    sudo mkdir -p $default_storage
fi

########################################
## | VALIDAÇÕES | ##
########################################

# Selecionar os diretórios de backups com base no argumento fornecido
case "$tipo_backup" in
    completo)
        echo "Realizando backup completo..."
        # Pastas Completas (Não pode ter nada em execução para não dar erros)
        backup_paths="/tmp /home/raffiz /root /var/log"
        ;;
    personalizado)
        echo "Realizando backup personalizado..."
        # Backup da pasta inteira "raffiz" excluindo ".config" e ".cache"
        backup_paths="/home/raffiz/Documents /home/raffiz/Downloads /home/raffiz/Pictures /home/raffiz/Videos /var/log"
        exclude_paths="--exclude=/home/raffiz/.config --exclude=/home/raffiz/.cache"
        ;;
    *)
        exibir_ajuda
        exit 1
        ;;
esac

# Verificar se os diretórios de backup existem
for path in $backup_paths; do
    if [ ! -d "$path" ] && [ ! -f "$path" ]; then
        echo "Erro: o diretório ou arquivo $path não existe."
        exit 1
    fi
done

#############################################
## | PROCESSO_BACKUP | ##
#############################################

# Opções do tar: c = para criar o arquivo; z = para compactar no formato gzip (.gz)
# S = Verificação inteligente (não fazer backup de arquivos vazios); p = preserva permissões de arquivos; f = final sempre, para indicar o arquivo.
# Primeiro ele vai localizar onde o arquivo vai ser salvo e depois qual arquivo ele vai salvar.
# Vai gerar uma mensagem
printf "\n ### Compactando arquivos ### \n"
if [ "$tipo_backup" == "personalizado" ]; then
    if tar czSpf "$external_storage/$final_archive" $exclude_paths $backup_paths; then
        printf "[$date_format] Backup $tipo_backup feito com SUCESSO!\n" >> $log_file
    else
        printf "[$date_format] Backup não realizado!\n" >> $log_file
    fi
else
    if tar czSpf "$external_storage/$final_archive" $backup_paths; then
        printf "[$date_format] Backup $tipo_backup feito com SUCESSO!\n" >> $log_file
    else
        printf "[$date_format] Backup não realizado!\n" >> $log_file
    fi
fi

# Desmontar o dispositivo se foi montado no script
if [ -n "$dispositivo_local" ]; then
    echo "Desmontando o dispositivo $dispositivo_local"
    sudo umount $external_storage
fi
