#!/bin/bash
#
# Ignorar partições especificadas
ignored_partitions="/dev /dev/shm /run /sys/fs/cgroup /u01 /u02 /u03"

# Define o nome do host e o primeiro IP
hostname=$(hostname)
ip_address=$(hostname -I | awk '{print $1}')

# Pega o mais usado, ignorando as partições especificadas
espaco=$(df -h | grep -vE "$(echo $ignored_partitions | sed 's/ /|/g')" | awk '{print $5}' | grep -v Use | sort -nr | awk -F % '{print $1}' | head -n1)
#
# Pega o uso e espaço livre
var=$(df -h | grep -vE "$(echo $ignored_partitions | sed 's/ /|/g')" | grep -e $espaco | awk '{ print " Particao " $6  " | Tamanho " $2 " | Usado "  $3 " | Disponivel " $4 " | Uso: "$5 }')
#
# Verifica se o arquivo existe e cria caso não exista.
if [ -e /tmp/scriptemailhd.log ]; then :; else echo $espaco > /tmp/scriptemailhd.log; fi
#
# Verifica se o espaço em disco continua igual à última leitura
if [ "$espaco" -eq "$(cat /tmp/scriptemailhd.log)" ]; then
    echo "Espaco continua igual" >/dev/null
else
    #
    # Se o espaço tiver diferente da última leitura e tiver maior que 89% de uso, envia email
    if [ "$espaco" -gt 89 ]; then
        echo "espaco igual ou maior que 90" >/dev/null

        # Cria o conteúdo do e-mail
        email_subject="$hostname IP: $ip_address $espaco% Uso do disco"
        email_body="$hostname IP: $ip_address Uso de disco: $espaco% \n $var"

        # Envia o e-mail usando mailx
        echo -e "$email_body" | mailx -r "envia-alerta@email.com.br" -s "$email_subject" lista-recebe-alerta@email.com.br
    else
        echo "espaco menor que 90" >/dev/null
    fi
fi
#
# Atualiza o espaço de disco no arquivo
echo $espaco > /tmp/scriptemailhd.log
