```bash
mongodump --db my_database --out /home/artem/git/hub/gdc-prj/base-block/databases/chapter-4/mongodb.dump
mongorestore --db my_database --drop mongodb.dump/my_database/
```
```bash
sudo nano /etc/redis/redis.conf
save 60 1000       
save 300 10        
dir /var/lib/redis
dbfilename dump.rdb
sudo systemctl restart redis
redis-cli
set testkey "backup_check"
save
ls -lh /var/lib/redis/dump.rdb
redis-cli get testkey
sudo systemctl stop redis
sudo systemctl start redis
redis-cli get testkey
```