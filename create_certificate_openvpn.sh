#!/bin/bash

clear
echo "#########################
# Servidor de OpenVPN   #
#########################"
echo " "

echo " "
echo " "

echo "Digite o endereço interno do servidor de VPN [192.168.1.20]:"
read ip
if [ -z $ip ];then ip="192.168.1.20"; fi

echo "Digite o endereço externo do servidor e VPN [231.183.65.120]:"
read ipext
if [ -z $ipext ];then ipext="231.183.65.120"; fi

echo "Digite o dominio do servidor de VPN [laurodepaula.com.br]:"
read domi
if [ -z $domi ];then domi="laurodepaula.com.br"; fi        

echo "Digite a porta de escuta do servidor de VPN [1194]:"
read port
if [ -z $port ];then port="1194"; fi

echo "Digite o mone do clente que vai usar a VPN [raspi]:"
cliente=$1
if [ -z $cliente ];then cliente="raspi"; fi

echo "Criando um certificado DH"
openssl dhparam -out dh2048.pem 2048

echo "Criando uma chave TLS"
openvpn --genkey --secret tls.key
sleep 1

echo "Criando a Certificado CA"
sleep 1

echo "Gerando chave privada da CA"
openssl genrsa -out rootCA.key 2048
sleep 1

echo "Gerando certificado autoassinado da CA"
openssl req -out rootCA.cert -key rootCA.key -new -x509 -days 3650 -subj "/C=BR/ST=Pernambuco/L=Recife/O=Suporte Avancado/O=Security/CN=root.$domi"
sleep 1

#Certificado do servidor
echo "Gerando chave privada do servidor"
openssl genrsa -out VPNserver.key 2048
sleep 1

echo "Gerando certificado do servidor"
openssl req -out VPNserver.req -key VPNserver.key -new -days 365 -subj "/C=BR/ST=Pernambuco/L=Recife/O=Suporte Avancado/O=Security/CN=server.$domi"
sleep 1

echo "Assinando o certificado do servidor com a CA"
openssl x509 -in VPNserver.req -out VPNserver.cert -days 365 -req -CA rootCA.cert -CAkey rootCA.key -CAcreateserial
sleep 1

echo "Gerando arquivo de configuração do servidor ..."
cat <<EOF >$cliente.conf
local $ip
port $port
proto udp
dev tun
#alterar a rede conforme seu ambiente
server 10.8.250.0 255.255.255.240
#Alterar a rota conforme seu ambiente
push "route 192.168.0.0 255.255.255.0"
push "route 192.168.1.0 255.255.255.0"
push "route 192.168.2.0 255.255.255.0"
push "route 192.168.3.0 255.255.255.0"
duplicate-cn
keepalive 10 120
comp-lzo
cipher AES-256-CBC
persist-key
persist-tun
verb 3
key-direction 0
log             /var/log/openvpn-$cliente.log
log-append      /var/log/openvpn-$cliente-append.log
status          /var/log/openvpn-$cliente-status.log

<ca>
`cat rootCA.cert`
</ca>

<dh>
`cat dh2048.pem`
</dh>

<cert>
`cat VPNserver.cert`
</cert>

<key>
`cat VPNserver.key`
</key>

<tls-auth>
`cat tls.key`
</tls-auth>

EOF

c=($cliente)

for k in ${c[*]};do
        echo "Gerando chave privada do cliente $k"
        openssl genrsa -out $k.key 2048
	#openssl genpkey -algorithm RSA -out $k.key -aes-128-cbc -pass pass:hello
	#openssl genrsa -aes128 -passout pass:foobar 2048 > "$k".key
	#openssl genrsa -aes128 -passout file:senha.txt 3072 > "$k".key
        sleep 1

        echo "Gerando requisição do certificado do cliente $k"
        openssl req -sha256 -new -key $k.key -outform PEM -out $k.csr -subj "/C=BR/ST=Pernambuco/L=Recife/O=HOME/O=Security/CN=$k.$domi" -new -days 365
        sleep 1

        echo "Assinando o certificado do cliente $k com a CA"
        openssl x509 -in $k.csr -out $k.cert -days 365 -req -CA rootCA.cert -CAkey rootCA.key -CAcreateserial

        echo "Gerando arquivo de configuração do cliente $k"

        cat <<EOF >$k.ovpn
client
dev tun
proto udp
remote $ipext
port $port
resolv-retry infinite
nobind
persist-key
persist-tun
comp-lzo
verb 3
key-direction 1

<ca>
`cat rootCA.cert`
</ca>

<cert>
`cat $k.cert`
</cert>

<key>
`cat $k.key`
</key>

<tls-auth>
`cat tls.key`
</tls-auth>

EOF

done

echo "CHECANDO ASSINATURA DA CA COM O CERTIFICADO DO CLIENTE"
openssl verify -CAfile rootCA.cert -purpose sslclient $cliente.cert

echo "CHECANDO ASSINATURA DA CA COM O CERTIFICADO DO SERVIDOR"
openssl verify -CAfile rootCA.cert -purpose sslserver VPNserver.cert

rm -f rootCA.* VPNserver.* tls* dh*
rm -f $k.cert $k.key $k.csr

