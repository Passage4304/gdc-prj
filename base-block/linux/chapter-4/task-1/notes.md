### Ротация логов через cron
```bash
* * */3 * * find /home/artem/git/hub/gdc-prj/base-block/linux/chapter-4/task-1/logs* -mtime +3 -print >> /home/artem/learning/scripts/logs/cron.log 
* * */3 * * find /home/artem/git/hub/gdc-prj/base-block/linux/chapter-4/task-1/logs* -mtime +3 -delete
```