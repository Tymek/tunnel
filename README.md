# scrlk/tunnel
Remote SSH Tunel server with key authentication.

Example client command: `ssh -N -R 8080:localhost:80 -p 2222 docker@your.example.com`

Example `docker-compose.yml`:

``` yml
version: '3.6'

services:
  relay:
    image: scrlk/tunnel
    restart: always
    environment:
      AUTHORIZED_KEYS: ${AUTHORIZED_KEYS:-}
    ports:
      - "2222:22"
      - "8080:80"
    volumes:
      - ./data/relay:/srv
```

You can also use redirected ports inside docker `network`, without publishing them.
