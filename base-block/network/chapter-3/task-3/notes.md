### CURL
```bash
### POST ###
curl -X POST <URL> \
  -H "Content-Type: application/json; charset=UTF-8" \
  -d '{"<field><number>": "<value>", "<field><number + 1>": "<value>", "<field><number + 2>": <value>, "<field><number + n>": <value>}'
### PUT ###
curl -X POST <URL>/<category> \
  -H "Content-Type: application/json; charset=UTF-8" \
  -d '{"<field><number>": "<value>", "<field><number + 1>": "<value>", "<field><number + 2>": <value>, "<field><number + n>": <value>}'
### DELETE ###
curl -X DELETE <URL>/<category> -H "Accept: application/json"
```