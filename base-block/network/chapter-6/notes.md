### WireGuard
#### Server
```bash
sudo apt install wireguard
sudo vim /etc/wireguard/wg0.conf
```
```ini
[Interface]
PrivateKey = <server-private-key>
Address = 10.0.0.1/24

[Peer]
PublicKey = <client-public-key>
AllowedIPs = 10.0.0.2/32
```
```bash
sudo wg-quick up wg0
sudo iptables -A INPUT -p udp --dport <wg-port> -j ACCEPT
sudo iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o <intreface-name> -j MASQUERAD
sudo netfilter-persistent save
### разрешаем IP-forwarding ###
sudo vim /etc/sysctl.conf
```
```ini
net.ipv4.ip_forward = 1
```
```bash
sudo sysctl -p
##############################
```
#### Client
```bash
sudo apt install wireguard
sudo vim /etc/wireguard/wg0.conf
```
```ini
[Interface]
PrivateKey = <client-private-key>
Address = 10.0.0.2/24

[Peer]
PublicKey = <server-public-key>
Endpoint = <server-ip-address>:<server-port>
AllowedIPs = 0.0.0.0/0
```
```bash
sudo wg-quick up wg0
```

### OpenVPN
#### Server
```bash
sudo apt update
sudo apt install openvpn easy-rsa -y
make-cadir ~/openvpn-ca
cd ~/openvpn-ca
./easyrsa init-pki # инициализируем PKI
./easyrsa build-ca # создание корневого сертификата
./easyrsa gen-req server nopass # запрос на серверный сертификат
./easyrsa sign-req server server # подпись запроса
./easyrsa gen-req client1 nopass # запрос на клиентский сертификат
./easyrsa sign-req client client1 # подпись запроса
./easyrsa gen-dh # генерация dh параметров
./openvpn --genkey --secret ta.key # создание tls-auth ключа
### Перенести сертификаты в /etc/openvpn/server/ ###
sudo vim /etc/openvpn/server/server.conf
```
```
port 1194
proto udp
dev tun
ca ca.crt
cert server.crt
key server.key
dh dh.pem
auth SHA256
tls-auth ta.key 0
topology subnet
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
keepalive 10 120
persist-key
persist-tun
status openvpn-status.log
log-append /var/log/openvpn.log
verb 3
explicit-exit-notify 1
```
```bash
### Разрешаем IP-forwarding ###
### Открываем порт 1194 ###
### Настраиваем правило маскарадинга ###
sudo systemctl start openvpn@server
sudo systemctl enable openvpn@server
```

#### Client
```bash
sudo vim client.ovpn
#################################
client
dev tun
proto udp
remote your.server.ip 1194
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
auth SHA256
cipher AES-256-CBC
tls-auth ta.key 1
verb 3

<ca>
(вставь содержимое ca.crt)
</ca>

<cert>
(вставь содержимое client1.crt)
</cert>

<key>
(вставь содержимое client1.key)
</key>

<tls-auth>
(вставь содержимое ta.key)
</tls-auth>
################################
sudo openvpn --config client.ovpn
```

### Test
#### Что такое фаервол в Linux?
B) Программный или аппаратный компонент для фильтрации сетевого трафика

### Какой командой можно добавить правило для разрешения входящих SSH-соединений через iptables?
B) iptables -A INPUT -p tcp --dport 22 -j ACCEPT

### Для чего предназначена таблица NAT в iptables?
B) Для изменения адресов и портов в пакетах

### Что из перечисленного относится к основным цепочкам iptables?
B) FILTER, OUTPUT, INPUT

### Как включить фаервол ufw?
B) sudo ufw enable

### Чем отличается nftables от iptables?
A) nftables использует единую архитектуру для всех протоколов

#### Какая команда используется для просмотра всех правил в nftables?
B) sudo nft list ruleset

### Какой протокол обеспечивает более высокую производительность: OpenVPN или WireGuard?
B) WireGuard

### Какую команду нужно выполнить для включения VPN через WireGuard?
C) sudo wg-quick up <config>

### Какой ключевой принцип работы VPN?
A) Создание зашифрованного туннеля между устройством пользователя и сервером


