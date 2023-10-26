#!/bin/bash
# O script tem a intenção de bloquear um range de ip de um determinado país, para saber o códio do páis verificar na url informada abaixo.
# See url for more info - http://www.cyberciti.biz/faq/?p=3402
# Author: nixCraft <www.cyberciti.biz> under GPL v.2.0+
# Adaptação para pt-br: Leonardo F. Costa <www.difusao.tech>
# -----------------------------------------------------------------------------

#Inserir neste ponto os países que serão bloqueados, verificar na url: http://www.ipdeny.com/ipblocks
ISO="ir ru af cn"
### Variáveis ​​para facilitar o uso do script que aponta para iptables, wget para baixar os arquivos da base de dados e egrep para selecionar o IP sem nenhum símbolo que iptables não possa interpretar ###

IPT=/sbin/iptables
WGET=/usr/bin/wget
EGREP=/bin/egrep

#Nova tabela com as regioes para banir
SPAMLIST="countrydrop"
#Local da base de dados
ZONEROOT="/root/iptables"
#URL com os ips dos países
DLROOT="http://www.ipdeny.com/ipblocks/data/countries"
#Funcao que vai limpar as configuracoes default do iptables

cleanOldRules() {
    $IPT -F
    $IPT -X
    $IPT -t nat -F
    $IPT -t nat -X
    $IPT -t mangle -F
    $IPT -t mangle -X
    $IPT -P INPUT ACCEPT
    $IPT -P OUTPUT ACCEPT
    $IPT -P FORWARD ACCEPT
}


#Criamos o diretorio para criar a base de dados.
[ ! -d $ZONEROOT ] && /bin/mkdir -p $ZONEROOT

#Executamos a função de limpeza do iptables
cleanOldRules

#Criamos a tabela do iptables com o nome da variável SPAMLIST
$IPT -N $SPAMLIST

for c in $ISO; do
    # Base de dados das zonas à bloquear.
    tDB=$ZONEROOT/$c.zone

    # Baixamos a base de datos atualizada.
    $WGET -O $tDB $DLROOT/$c.zone

    # Mensagem do país bloqueado que aparecerá no log do iptables
    SPAMDROPMSG="$c País bloqueado"

    # Filtramos a base de dados para que o iptables interprete corretamente a base de dados e vamos analisar cada bloco de IP.
    BADIPS=$(egrep -v "^#|^$" $tDB)
    for ipblock in $BADIPS; do
        $IPT -A $SPAMLIST -s $ipblock -j LOG --log-prefix "$SPAMDROPMSG"
        $IPT -A $SPAMLIST -s $ipblock -j DROP
    done
done

# Drop todo
$IPT -I INPUT -j $SPAMLIST
$IPT -I OUTPUT -j $SPAMLIST
$IPT -I FORWARD -j $SPAMLIST

exit 0
