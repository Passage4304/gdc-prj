### Перехват Ethernet трафика с помощью tcdpump
```bash
sudo tcpdump -i <interfacename> -e -c 50 -w $(date +%y-%m-%d_%H-%M-%S)-dump.pcap
```

### Перехват icmp трафика с помощью tcpdump
```bash
sudo tcpdump -i <interfacename> icmp
```

### Перехват ip трафика с помощью tcpdump
```bash
sudo tcpdump -i <interfacename> ip
```

### Перехват tcp/udp трафика с помощью tcpdump
```bash
sudo tcpdump -i <interfacename> tcp
sudo tcpdump -i <interfacename> udp
```

### Перехват http/dns трафика с помощью tcpdump
```bash
sudo tcpdump -i <interfacename> -A port 80
sudo tcpdump -i <interfacename> port 53
```

### Поменять TTL для команды ping
ping -t 1 google.com
