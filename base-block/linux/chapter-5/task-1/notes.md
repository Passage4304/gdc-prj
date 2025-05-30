### Поиск пакета по имени или описанию
```bash
apt-cache search <package-info>
apt-cache show <package-name> # если в названии и кратком описании нет <package-info>
```

### Установка пакета
```bash
sudo apt install <package-name>
```

### Обновление определенного пакета
```bash
sudo apt install --only-upgrade <package-name>
```

### Удаление пакетов
```bash
sudo apt remove <package-name>
```

### Откат пакета
```bash
ls /var/cache/apt/archives | grep <package-name>
 # пытаемся найти старую версию пакета в хэше
sudo dpkg -i /var/cache/apt/archives/<package-name>_<version>_amd64.deb # устанавливаем старую версию
```