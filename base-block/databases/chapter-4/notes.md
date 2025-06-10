#### MongoDB
```bash 
mongosh
```
```sql
use my_database
db.createCollection("users")
db.users.insertOne({
  user_id: 1,
  age: 25,
  friends: [2, 3, 4] // массив ID друзей
})
db.users.insertMany([
  { user_id: 2, age: 30, friends: [1, 4] },
  { user_id: 3, age: 28, friends: [1] },
  { user_id: 4, age: 35, friends: [1, 2] }
])
db.users.find().pretty()
db.users.createIndex({ user_id: 1 }, { unique: true })
db.users.find({ age: { $gt: 20 } })
db.users.find({ user_id: 3 }, { user_id: 1, friends: 1, _id: 0 })
db.users.find({ friends: { $size: 3 } })
db.users.find().sort({ age: -1 })
db.users.updateOne({ user_id: 5 }, { $set: { posts: [ { post_id: 103, content: 101001000000010101, date: 2022-01-01 } ] } })
db.users.find(
  {
    posts: { $elemMatch: { content: 1010001010 } }
  },
  {
    posts: 1,
    user_id: 1
  }
)
db.users.createIndex({ name: 1 });
db.users.find({ name: "Petr" }).explain("executionStats");
db.users.deleteMany({ age: { $lt: 18 } })
```
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