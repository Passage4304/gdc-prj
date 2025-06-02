### saskatoon
```bash
awk '{print $1}' <filename>.log | sort | uniq -c | sort -nr | head -n 1
```

### bata
```bash
grep -R <pattern> <path>
```