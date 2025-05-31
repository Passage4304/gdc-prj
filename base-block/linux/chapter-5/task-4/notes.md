### Создание структуры проекта
```bash
mkdir -p ~/my-pkg/etc/my-pkg
mkdir -p ~/my-pkg/DEBIAN
echo "# Test config" > ~/my-pkg/etc/my-pkg/app.conf
```

### Создание контрольного файла
```bash
vim ~/my-pkg/DEBIAN/control
```
Пример файла:
```plaintext
Package: config
Version: 1.0
Section: base
Priority: optional
Architecture: all
Maintainer: Your Name <your-email.domain>
Description: Пример .deb-пакета с конфигурационными файлами
```

### Сборка пакета
```bash
dpkg-deb --build ~/my-pkg
```

### Установка пакета
```bash
sudo dpkg -i my-pkg.deb
```

### Проверка
```bash
cat /etc/my-pkg/app.conf
```

### Удаление пакета
```bash
sudo dpkg -r my-pkg
```