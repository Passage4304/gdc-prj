### Nginx
```bash
sudo apt install nginx # устанавливаем пакет nginx 
nginx -v # проверяем установку
sudo vim /etc/nginx/sites-available/mysite # создаем файл конфигурации для сайта
```
Пример конфигурационного файла:
```nginx
server {
    listen 80;
    server_name mysite.local;

    root /var/www/mysite;
    index index.php index.html;

    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php<php-version>-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }

    error_log /var/log/nginx/mysite_error.log;
    access_log /var/log/nginx/mysite_access.log;
}
```
```bash
sudo ln -s /etc/nginx/sites-available/mysite /etc/nginx/sites-enabled/ # активируем конфигурационный файл
sudo nginx -t
sudo systemctl reload nginx
```

### PHP
```bash
sudo apt install php-fpm php-mysql # устанавливаем PHP
```

### PHPMyAdmin
```bash
sudo apt install phpmyadmin # установка phpmyadmin
sudo ln -s /usr/share/phpmyadmin /var/www/mysite/phpmyadmin # подключение к nginx
```

### Добавляем локальное доменное имя
```bash
sudo vim /etc/hosts
127.0.0.1 mysite.local
```

### Размещаем PHP-проект
```bash
cd /var/www
git clone <github-repo-of-project.git> mysite
sudo chown -R www-data:www-data /var/www/mysite 
sudo chmod -R /var/www/mysite # выставляем владельца и нужные права
```

### Устанавливаем и настраиваем СУБД MySQL
```bash
sudo apt install mysql
sudo mysql # заходим в MySQL
```
Создаем пользователя БД для сайта и выдаем ему права:
```SQL
CREATE DATABASE mysite_db;
CREATE USER 'mysite_user'@'localhost' IDENTIFIED BY '<password>';
GRANT ALL PRIVILEGES ON mysite_db.* TO 'mysite_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```
```bash
mysql -u mysite_user -p mysite_db < /var/www/mysite/database.sql # импортируем дамп базы, при наличии
```

### Настраиваем PHP проект (при необходимости)
Исправление переменных, проверка работоспособности логики и т.д.