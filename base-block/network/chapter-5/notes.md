### Reverse-proxy nginx
```bash
### Создаем Python Flask приложение ###
### Запускаем Python Flask приложение ###
sudo vim /etc/nginx/sites-available/mysite # открываем конфигурационный файл сайта nginx
################################
upstream flask_backend {
    server 127.0.0.1:5001;
    server 127.0.0.1:5002;
}

server {
    listen 80;
    server_name mysite.local;

    root /var/www/html;
    index index.php index.html;

    location /api/ {
        proxy_pass http://127.0.0.1:5000/; # основная настройка, отвечающая за обратный прокси
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
    error_log /var/log/nginx/mysite_error.log;
    access_log /var/log/nginx/mysite_access.log proxy_log;
}
### Добавляем форматирование access лога ###
sudo vim /etc/nginx/nginx.conf
###########################################
log_format proxy_log '$remote_addr - $remote_user [$time_local] '
                     '"$request" $status $body_bytes_sent '
                     '"$http_referer" "$http_user_agent" '
                     'upstream: $upstream_addr, status: $upstream_status, time: $upstream_response_time';
```

### Optional tasks
```bash
### Настройка HTTPS Let`s encrypt ###
### Делаем сайт доступным по доменному имени ###
### Устанавливаем certbot для nginx ###
sudo apt update
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d <yourdomain.name> -d <youranotherdomain.name> # настройка самого сертифика
sudo certbot renew --dry-run # проверка автообновления сертификата
### Кеширование статического контента ###
sudo vim /etc/nginx/sites-available/mysite
#########################################
location ~* \.(jpg|jpeg|png|gif|ico|css|js|woff|woff2|ttf|svg)$ {
    expires 30d;
    add_header Cache-Control "public";
}
### Настройка базовой аутентификации ###
sudo apt install apache2-utils # скачиваем apache2-utils
sudo htpasswd -c /etc/nginx/.htpasswd <username> # создаем пользователя и пароль
sudo vim /etc/nginx/sites-available/mysite
#########################################
location /secret/ {
    auth_basic "Restricted Content";
    auth_basic_user_file /etc/nginx/.htpasswd;

    proxy_pass http://127.0.0.1:5001;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
}
```

### Test
#### Что такое виртуальный сервер (server block) в Nginx?
B) Блок в конфигурации Nginx для управления отдельными доменами

#### Какая директива отвечает за указание IP-адреса и порта в Nginx?
C) listen

#### Для чего используется директива server_name?
B) Для определения доменов, которые обслуживает сервер

#### Какая директива задаёт корневой каталог для сервера?
A) root

#### Что определяет директива location в Nginx?
B) Правила маршрутизации запросов

#### Какой протокол поддерживает шифрование соединений в Nginx?
B) HTTPS

#### Для чего используется балансировка нагрузки в Nginx?
B) Для распределения запросов между несколькими серверами

#### Какую директиву используют для настройки SSL/TLS в Nginx?
A) ssl_certificate

#### Какой файл обычно редактируют для изменения конфигурации Nginx?
B) /etc/nginx/nginx.conf

#### Какая из следующих директив используется для поддержки HTTP/2 в Nginx?
B) listen 443 ssl http2;