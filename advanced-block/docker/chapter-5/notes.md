#### TLS
```bash
openssl genrsa -aes256 -out ca-private.pem 4096 # генерируем закрытый ключ для удостоверяющего центра
openssl req -new -x509 -days 365 -key ca-private.pem -sha256 -out ca-public.pem # генерируем открытый ключ для удостоверяющего центра на основе закрытого
openssl genrsa -out server-key.pem 4096 # генерируем закрытый серверный ключ
openssl req -subj "/CN=itsecforu.ru" -sha256 -new -key server-key.pem -out request.csr # генерируем запрос на подписание серверного сертификата
echo subjectAltName = DNS:sub.itsecforu.ru;IP=192.168.0.1 >> extfile.cnf # создаем файл расширения для dns имени и ip адреса сервера
echo extendedKeyUsage = serverAuth >> extFile.cnf # добавляем в файл расширения информацию о серверной аутентификации
### Генерируем подписанный сертификат сервера ###
openssl x509 -req -days 365 -sha256 \
    -in request.csr \
    -CA ca-public.pem \
    -CAkey ca-private.pem \
    -CAcreateserial \
    -extfile extfile.cnf \
    -out certificate.pem
openssl genrsa -out client-key.pem 4096 # генерируем закрытый клиентский ключ
openssl req -subj '/CN=client' -new -key client-key.pem -out client-request.csr # генерируем запрос на подписание клиентского сертификата
echo extendedKeyUsage = clientAuth >> extfile-client.cnf # добавляем информацию о клиентской аутентификации в файл расширения
### Генерируем подписанный клиентский сертификат ###
openssl x509 -req -days 365 -sha256 \
     -in client-request.csr \ 
     -CA ca-public.pem \
     -CAkey ca-private.pem \
     -CAcreateserial \
     -extfile extfile-client.cnf \
     -out client-certificate.pem
### Настраиваем docker-daemon ###
{
  "hosts": ["tcp://0.0.0.0:2376", "unix:///var/run/docker.sock"],
  "tls": true,
  "tlsverify": true,
  "tlscacert": "/etc/docker/ssl/ca.pem",
  "tlscert": "/etc/docker/ssl/server-cert.pem",
  "tlskey": "/etc/docker/ssl/server-key.pem"
}
sudo systemctl restart docker # перезапускаем docker
### Подключаемся с TLS ###
docker --tlsverify \
  --tlscacert=ca-public.pem \
  --tlscert=client-certificate.pem \
  --tlskey=client-key.pem \
  -H=tcp://192.168.1.100:2376 info
```