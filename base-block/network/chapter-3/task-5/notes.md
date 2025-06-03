### HTTP/1.1 / HTTP/2 differences
```bash
### Проверяем поддерживает ли nginx HTTP/2 ###
nginx -v # Версия должна быть 1.9.5+
nginx -V 2>&1 | grep --color http_v2 # Проверяем наличие модуля
### Настраиваем конфиг сайтов ###
# HTTP/2 на 443
server {
    listen 443 ssl http2;
    server_name localhost;

    ssl_certificate     /home/you/ssl/server.crt;
    ssl_certificate_key /home/you/ssl/server.key;

    root /var/www/html;
    index index.html;
}

# HTTP/1.1 на 4443
server {
    listen 4443 ssl;  # без http2
    server_name localhost;

    ssl_certificate     /home/you/ssl/server.crt;
    ssl_certificate_key /home/you/ssl/server.key;

    root /var/www/html;
    index index.html;
}
### Включаем конфигурацию и перезапускаем сервер ###
sudo ln -s /etc/nginx/sites-available/http2-test /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
### Создаем HTML страницу с ресурсами
sudo mkdir -p /var/www/http2-test
cd /var/www/http2-test
sudo vim index.html
########################
<!DOCTYPE html>
<html>
<head>
    <title>HTTP/2 Test</title>
    <link rel="stylesheet" href="style.css">
    <script src="script.js" defer></script>
</head>
<body>
    <h1>Testing HTTP/1.1 vs HTTP/2</h1>
    <img src="img1.jpg" alt="img1">
    <img src="img2.jpg" alt="img2">
    <img src="img3.jpg" alt="img3">
    <img src="img4.jpg" alt="img4">
    <img src="img5.jpg" alt="img5">
    <img src="img6.jpg" alt="img6">
    <img src="img7.jpg" alt="img7">
    <img src="img8.jpg" alt="img8">
    <img src="img9.jpg" alt="img9">
    <img src="img10.jpg" alt="img10">
</body>
</html>

```