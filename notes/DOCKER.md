# Docker

Landing page for info about the docker container of this project.

## Instructions

```
docker build -t tapedeck:latest .
docker run -p 3000:3000 tapedeck

docker run -it --rm \
-v ${PWD}:/app \
-v /app/node_modules \
-p 3000:3000 \
-e CHOKIDAR_USEPOLLING=true \
tapedeck:latest 
```

Docker compose

```
# don't always need --build
docker-compose up -d --build
docker-compose ps
docker-compose logs tapedeck
docker-compose exec -it tapedeck /bin/sh
docker-compose stop
```
