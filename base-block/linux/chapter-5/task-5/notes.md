### Локальный репозиторий
```bash
mkdir -p ~/myrepo/{conf,dists/stable/main/binary-amd64,packages} # создаем структуру для репозитория
cp <package-name>.deb ~/myrepo/packages/ # складываем пакет в нужную папку
sudo apt install dpkg-dev # устанавливаем утилиту для работы с репозиториями и пакетами, если не установлена ранее
cd ~/myrepo/packages 
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz # генерируем индекс пакетов
### Поднимаем http сервер, чтобы сделать репозиторий доступным локально
cd ~/myrepo
python3 -m http.server 8000
echo "deb [trusted=yes] http://localhost:8000/packages ./" | sudo tee /etc/apt/sources.list.d/myrepo.list # добавляем запись о репозитории
### Обновляем список репозиториев и устанавливаем пакет
sudo apt update
sudo apt install configs
```

### Проверка
```bash
### Меняем информацию о пакете, пересобираем его
cd ~/my-pkg/
vim ~/my-pkg/etc/app.conf
```
```plaintext
# New config info
```
```bash
dpkg-deb --build configs.deb
cp configs.deb ~/my-repo/ # Переносим измененный пакет в директорию репозитория
cd ~/my-repo
rm Packages.gz # Удаляем старый индекс пакета
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz # Создаем новый индекс
sudo apt update
sudo apt install --upgrade-only configs # устанавливаем обновленный пакет
cat /etc/my-pkg/app.conf # проверяем изменения
```


