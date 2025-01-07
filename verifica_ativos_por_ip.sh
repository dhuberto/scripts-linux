#!/bin/bash
#Verifica ativos por ip na rede local
#
# 10.1.0.50
ping -q -c5 10.1.0.50 >/dev/null && grep -c "10.1.0.50f" /etc/scripts/10.1.0.50.log >/dev/null
if [ $? -eq 0 ]; then
echo 'Sw 10.1.0.50 Comunicacao as '`date +%D/\ as\ %H:%M:%S`'' | mutt -s 'Sw 10.1.0.50 com Comunicacao '`date +%D-%H:%M:%S`'' alerta@email.com
fi
ping -q -c5 10.1.0.50 >/dev/null  ||  nc -zv4 -w 60 10.1.0.50 80 2>/dev/null
if [ $? -eq 0 ]; then echo "10.1.0.50ok" > /etc/scripts/10.1.0.50.log
else
if [ `grep -c "10.1.0.50f" /etc/scripts/10.1.0.50.log` -gt 0 ]; then echo 'sw fail' >/dev/null
else
echo 'Sw 10.1.0.50  Sem Comunicacao '`date +%D/\ as\ %H:%M:%S`'' | mutt -s 'Sw 10.1.0.50  Sem Comunicacao '`date +%D-%H:%M:%S`'' alerta@email.com
echo "10.1.0.50f" > /etc/scripts/10.1.0.50.log
fi
fi

# 10.1.0.23
ping -q -c5 10.1.0.23 >/dev/null && grep -c "10.1.0.23f" /etc/scripts/10.1.0.23.log >/dev/null
if [ $? -eq 0 ]; then
echo 'Sw 10.1.0.23  com Comunicacao as '`date +%D/\ as\ %H:%M:%S`'' | mutt -s 'Sw 10.1.0.23  com Comunicacao '`date +%D-%H:%M:%S`'' alerta@email.com
fi
ping -q -c5 10.1.0.23 >/dev/null  ||  nc -zv4 -w 60 10.1.0.23 80 2>/dev/null
if [ $? -eq 0 ]; then echo "10.1.0.23ok" > /etc/scripts/10.1.0.23.log
else
if [ `grep -c "10.1.0.23f" /etc/scripts/10.1.0.23.log` -gt 0 ]; then echo 'sw fail' >/dev/null
else
echo 'Sw 10.1.0.23  Sem Comunicacao '`date +%D/\ as\ %H:%M:%S`'' | mutt -s 'Sw 10.1.0.23  Sem Comunicacao '`date +%D-%H:%M:%S`'' alerta@email.com
echo "10.1.0.23f" > /etc/scripts/10.1.0.23.log
fi
fi
