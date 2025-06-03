### BIND configuration
```bash
### Устанавливаем утилиты bind9 ###
sudo apt update
sudo apt install bind9 bind9utils bind9-doc dnsutils
### Настраиваем зону ###
sudo vim /etc/bind.named.conf.local
########################
zone "<domain>.<name>" {
    type master;
    file "/etc/bind/zones/db.<domain>.<name>";
};
### Создаем директорию для зон ###
sudo mkdir -p /etc/bind/zones
### Создаем файл зоны ###
sudo vim /etc/bind/zones/db.<domain>.<name>
########################
$TTL    604800
@       IN      SOA     ns.<domain>.<name>. admin.<domain>.<name>. (
                        2025060201 ; Serial (увеличивать при изменениях)
                        604800     ; Refresh
                        86400      ; Retry
                        2419200    ; Expire
                        604800 )   ; Negative Cache TTL

; Зона начинается здесь
@       IN      NS      ns.<domain>.<name>.

; Адреса
ns      IN      A       127.0.0.1
www     IN      A       192.168.1.100
api     IN      CNAME   www
mail    IN      A       192.168.1.101
@       IN      MX 10   mail.<domain>.<name>.
### Проверка синтаксиса зоны ###
sudo named-checkzone <domain>.<name> /etc/bind/zones/db.<domain>.<name>
### Настройка named.conf.options ###
sudo vim /etc/bind/named.conf.options
########################
options {
    directory "/var/cache/bind";

    listen-on port 53 { 127.0.0.1; };  # или 0.0.0.0 для всех интерфейсов
    allow-query { 127.0.0.1; };        # или your subnet

    recursion yes;
    forwarders {
        8.8.8.8;
        8.8.4.4;
    };

    dnssec-validation auto;
};
### Перезапуск BIND ###
sudo systemctl restart bind9
### Проверка статуса BIND ###
sudo systemctl status bind9
### Проверка работоспособности сервера ###
dig @127.0.0.1 www.<domain>.<name>
dig @127.0.0.1 api.<domain>.<name>
dig @127.0.0.1 mail.<domain>.<name>
```