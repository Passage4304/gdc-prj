### Заметки
```bash
/etc/systemd/system/<daemon-name>.service # путь к демону
useradd -r -s /usr/sbin/nologin <daemon-username> # дополнительно: создаем пользователя для запуска демона от него
sudo chown <daemon-username> /usr/local/bin/<daemon-name>.py # выдаем владение скриптом демона пользователю демона
sudo chown <daemon-username> /var/log/<daemon-name>.log # выдаем владение лог-файлом демона пользователю демона
```