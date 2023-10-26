# block-iptables.sh

Bloqueio de país para servidores Linux usando iptables.

O script tem a intenção de bloquear um range de ip de um determinado país, para saber o códio do páis verificar na url informada abaixo.

Ver a sigla dos paises em: https://www.ipdeny.com/ipblocks

O bloqueio default do script está para os seguintes países ir, ru, af, cn.


Caso queria acrescentar mais zonas, baixe o script e edita a variável ISO acrescentando a sigla do país pretendido.

# Como usar:

Execute no terminal:
curl https://raw.githubusercontent.com/Leonardo-Ferreira-costa/block-iptables.sh/main/block-iptables.sh | sh
