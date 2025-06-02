### /proc/<PID>/stat explaining
https://manpages.ubuntu.com/manpages/oracular/ru/man5/proc_pid_stat.5.html

### lsof
```bash
lsof -p <PID> # посмотреть файлы, открытые процессом
```

### /proc/<PID>/fd
```bash
ls -la /proc/<PID>/fd # посмотреть в какие файловые дескрипторы пишет процесс
```

### /proc/meminfo
https://manpages.ubuntu.com/manpages/noble/en/man5/proc_meminfo.5.html