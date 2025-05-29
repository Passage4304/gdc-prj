### Разметка диска в MBR и форматирование раздела в ext4
```bash
sudo fdisk /dev/sd<n>
Интерактивное меню fdisk:
o # создание новой MBR таблицы разделов
n # создание нового раздела
p # primary
1 # номер раздела
<Enter> # начало диска по умолчанию
<Enter> # до конца диска
w # записать изменения и выйти
sudo mkfs.ext4 /dev/sd<n>
```

### Разметка диска в GPT и создание двух разделов: xfs и btrfs
```bash
sudo parted /dev/sd<n> --script mklabel gpt
sudo parted /dev/sd<n> --script mkpart primary xfs 1MiB 50%
sudo parted /dev/sd<n> --script mkpart primary btrfs 50% 100%
sudo mkfs.xfs /dev/sd<n>1
sudo mkfs.btrfs /dev/sd<n>2
```

### Использование parted для гибкой разметки диска
```bash
sudo parted /dev/sd<n> --script mklabel gpt
sudo parted /dev/sd<n> --script mkpart primary 1MiB 100%
sudo parted /dev/sd<n> --script set 1 lvm on
sudo pvcreate /dev/sd<n>1
sudo vgcreate vg_data /dev/sd<n>1
sudo lvcreate -L 5G -n lv_ext4 vg_data
sudo lvcreate -L 10G -n lv_xfs vg_data
sudo mkfs.ext4 /dev/vg_data/lv_ext4
sudo mkfs.xfs /dev/vg_data/lv_xfs
```

### Изменение настроек inodes
#### TODO:
Прописать изменение настроек inodes для файловых систем ext4 и xfs.

В Linux управление inodes как в ext4 или xfs в Btrfs не применяется напрямую — Btrfs не использует фиксированное число inodes при создании файловой системы. Вместо этого, количество inodes динамически управляется и зависит от доступного пространства. Однако можно управлять параметрами, которые влияют на поведение Btrfs (например, compression, autodefrag, и т.д.).

Команда для настроек возможных параметров inodes для btrfs файловой системы:
```bash
sudo mount -o defaults,autodefrag,compress=zstd /dev/sd<n>2 /mnt/btrfs_data
```

### Команды для проверки файловых систем
```bash
sudo tune2fs -l /dev/sd<n>1        # Параметры файловой системы
sudo e2fsck -n /dev/sd<n>1         # Проверка целостности (только чтение)
sudo xfs_info /dev/sdY1          # Информация о разделе
sudo xfs_repair -n /dev/sdY1     # Проверка (только диагностика, без изменений)
sudo btrfs filesystem show /mnt/btrfs_data     # Общая информация о Btrfs
sudo btrfs filesystem df /mnt/btrfs_data       # Использование пространства
sudo btrfs filesystem usage /mnt/btrfs_data    # Расширенная статистика
sudo btrfs check /dev/sdY2                     # Проверка ФС (офлайн, на размонтированном разделе)
```

### Монтирование разделов в директории
```bash
sudo mount /dev/sdb1 /mnt/disk1
sudo mount /dev/sdc1 /mnt/disk2/part1
sudo mount /dev/sdc2 /mnt/disk2/part2
sudo mount /dev/vg_data/lv_ext4 /mnt/disk3/part1
sudo mount /dev/vg_data/lv_xfs /mnt/disk3/part2
```

### Поиск больших файлов с помощью du
```bash
du -ahx . | sort -rh | head -5
```

### Проверка состояния дисков smartctl
```bash
smartctl -a /dev/sd<n>
```

### Проверка работоспособности опции sync
```bash
time bash -c "echo test > testfile" # выполняем сначала на sync файловой системе, а потом на async и сверяем время выполнения
```

### Квоты для ext4
```bash
sudo quotacheck -cugm -F vfsv0 /mnt/data #создание файла квот
sudo quotaon /mnt/data # включение квот
sudo repquota /mnt/data # проверка текущего состояния квот
sudo edquota -u user1 # открыть редактор квоты пользователя
/mnt/data blocks soft=1000000 hard=1100000 inodes soft=0 hard=0 # настройка квот для пользователя
sudo quotaon -p /mnt/data # проверка активности квот
sudo repquota /mnt/data # статистика пользователя по квотам
quota -u user1 # проверка квот конкретного пользователя
```

### Измерение скорости чтения и записи
```bash
fio --name=read_test --filename=testfile --bs=1M --rw=read --direct=1 --numjobs=1 --time_based --runtime=10s
fio --name=write_test --filename=testfile --size=1G --bs=1M --rw=write --direct=1 --numjobs=1 --time_based --runtime=10s
```

### IOSTAT
https://losst.pro/opisanie-iostat-linux#opisanie-iostat-linux