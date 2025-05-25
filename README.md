# 🗄️ Script de Backup para Slackware/Linux (via SSH)

Este é um script de **backup automatizado** escrito em Bash, criado para facilitar meus backups periódicos. Ele foi projetado inicialmente para Slackware, mas funciona perfeitamente em outras distros (como Arch, que uso atualmente), com foco em **automatização via terminal**.

Tenho o hábito de formatar o sistema regularmente, e manter um backup dos meus arquivos pessoais, configurações e lista de pacotes instalados economiza bastante tempo. O script faz o backup localmente e o envia via **SSH para outro servidor**, mantendo apenas os 5 backups mais recentes no destino.

> 🔒 Todo o processo é registrado em um arquivo de log para facilitar a auditoria ou debugging.

---

## ⚙️ Funcionalidades

- Compacta arquivos/diretórios escolhidos (.bashrc, Documentos, .ssh, etc.)
- Gera lista de pacotes instalados (`yay -Qq`)
- Envia o backup via `scp` para um servidor remoto
- Remove backups antigos no servidor, mantendo os 5 mais recentes
- Registra logs no sistema
- Pode ser usado com `cron` para backups automáticos

---

## 🚀 Como usar

1. **Clone o repositório:**
   ```
   git clone https://github.com/raffizmc/Script-Backup-Slackware.git
   cd Script-Backup-Slackware
   ```

2. Edite o script com seus caminhos e configurações de servidor:
```
servidor_destino="usuario@ip"
```

```
porta_ssh="22" (ou a porta que você usa)
```

```
destino_server="/caminho/no/servidor"
```

Dê permissão de execução:
```
chmod +x bkp.sh
```

4. (Opcional) Mova o script para um diretório no PATH:
```
sudo mv bkp.sh /usr/local/bin/bkp.sh
```

5. (Opcional) Adicione este alias no seu .bashrc para facilitar:
```
echo "alias log-bkp='tail -n 20 /var/log/backup/backup_diario.log'" >> ~/.bashrc
source ~/.bashrc
```

6. Execute manualmente:
```
bkp.sh
```

7. Verifique o log:
```
log-bkp
```
##
## 🛠️ Requisitos
```
yay (ou adapte o comando para seu gerenciador de pacotes, ex: pacman -Qq)

tar, scp, ssh, xargs

Permissão de escrita em /var/log/backup/
```
##

### [DICA] 📅 Automatizando com cron
Você pode agendar backups automáticos com cron. Exemplo para rodar toda segunda, quarta e sábado às 21h30:
Exemplo:
```
30 21 * * 1,3,6 /usr/local/bin/bkp.sh
```
Site mapa Crontab Guru:
```
https://crontab.guru/
```
#### Lembre-se de testar o script manualmente antes de automatizar.

Certifique-se de que o ssh-agent esteja configurado corretamente se estiver usando chave com senha.

##
## 💬 Feedback
Se quiser contribuir, relatar bugs ou dar sugestões, abra uma Issue aqui no GitHub.

RaffizMc - @2025
Licenciado sob CC BY-NC 4.0
