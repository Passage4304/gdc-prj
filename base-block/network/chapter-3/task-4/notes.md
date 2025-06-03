### Self-signed certificate for web-site
```bash
### Устанавливаем openssl ###
sudo apt update
sudo apt install openssl
### Проверяем версию openssl ###
openssl version
### Создаем директорию для сертификатов ###
mkdir -p <path>/<cert-dir-name>
cd <path>/<cert-dir-name>
### Генерируем закрытый ключ ###
openssl genrsa -out server.key 2048
### Генерируем самоподписанный сертификат ###
openssl req -new -x509 -key server.key -out server.crt -days 365 # Заполняем информацию для сертификата
### Настраиваем nginx ###
sudo vim /etc/nginx/sites-available/<name-of-site>
#########################
server {
    listen 443 ssl;
    server_name <domain>.<name>;

    ssl_certificate     <path/to/cert>;
    ssl_certificate_key <path/to/cert-key>;

    location / {
        return 200 'SSL is working!';
        add_header Content-Type text/plain;
    }
}
### Включаем конфигурацию сайта ###
sudo ln -s /etc/nginx/sites-available/<site-name> /etc/nginx/sites-enabled/
### Заменяем дефолтную конфигурацию ###
sudo mv /etc/nginx/sites-enabled/default /etc/nginx/sites-enabled/default.old
### Перезапуск nginx и проверка ###
sudo nginx -t
sudo systemctl reload nginx
```