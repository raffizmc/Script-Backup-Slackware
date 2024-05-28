c# Script de Backup para Slackware

Este é um script em Shell Script desenvolvido para realizar backups periódicos.

Como usuário do Slackware, costumo formatar o sistema a cada 6 meses, seguido pela mesma pós-instalação, que inclui o download manual dos mesmos arquivos.

Desenvolvi este script simples para efetuar um backup completo de um diretório específico, simplificando assim todo o processo. Tenho outros scripts de automação escritos em Shell, os quais pretendo compartilhar posteriormente. Embora não seja meu hábito comentar códigos, este script está bem documentado para facilitar o entendimento, sendo projetado para meu uso pessoal.

**Modo de Uso:**
1. Baixe o arquivo e conceda permissão de execução (`chmod +x bkp-completo.sh`).
2. Mova o arquivo para: `mv /usr/local/sbin/bkp-completo.sh`.
3. (Opcional) Crie uma abreviação no arquivo `.bashrc` com o seguinte comando: `alias log-bkp="cat /var/log/daily-backup.log"` para visualizar o log do backup com apenas o comando `log-bkp`.
4. Execute o script via terminal com `bkp-completo.sh`.
5. Verifique o log (`/var/log/daily-backup.log`) para saber se a operação foi bem-sucedida, pois o resultado não é exibido na tela. Dependendo do tamanho, a execução pode demorar alguns minutos.
6. (Opcional) Crie um cron job para agendar automaticamente os backups. Por exemplo, o seguinte cron job vai fazer backups na segunda, quarta e sábado às 21:30: "30 21 * * 1,3,6 /usr/local/sbin/bkp-completo -c"
Certifique-se de passar o argumento "-c" para o script "bkp-completo". Este argumento é crucial para o funcionamento adequado do backup no Cron job!
Se você precisa de ajuda para criar seus próprios cron jobs, pode dar uma olhada neste link para mais informações: CronTab Guru.

Esteja atento ao arquivo de log para obter detalhes importantes sobre o processo de backup, incluindo possíveis erros ou mensagens informativas.

## Feedback e Relatórios de Problemas

Se você tiver alguma dúvida, sugestão ou encontrar algum problema ao usar este script, por favor, sinta-se à vontade para abrir uma "Issue" no repositório do GitHub. Terei o prazer em ajudar e resolver qualquer problema encontrado.

RaffizMc está licenciado sob CC BY-NC 4.0 © 2024
