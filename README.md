## What's inside

* [Nginx](http://nginx.org/)
* [MySQL 5.6](http://www.mysql.com/)
* [PHP-FPM](http://php-fpm.org/)
* [phalcon](https://github.com/phalcon/cphalcon)
* [Memcached](http://memcached.org/)
* [Redis](http://redis.io/)
* [Elasticsearch 2.4.4](http://www.elasticsearch.org/)
* [Golang 1.8](https://golang.org/dl/)

## Requirements

* [Docker Engine](https://docs.docker.com/installation/)
* [Docker Compose](https://docs.docker.com/compose/)
* [Docker Machine](https://docs.docker.com/machine/)
* [Docker Machine Driver XHYVE](https://github.com/zchee/docker-machine-driver-xhyve)

## Get started

#### 1.Docker machine
Create docker machine by using `xhyve`

```sh
$ docker-machine create dev -d=xhyve --xhyve-cpu-count=2 --xhyve-memory-size=2048 --xhyve-experimental-nfs-share
```

set your docker machine `env` to use `dev` env

```sh
$ docker-machine env dev
```

#### 2.Docker-machine-nfs

To speedup your shared-folder, we use `docker-machine-nfs`
```
$ docker-machine-nfs dev \
    --mount-opts="noacl,async,nolock,vers=3,udp,noatime,actimeo=2" \
    --shared-folder="/Users/hary/Repo"
```

Below command will shutdown your docker-machine, so you need to start your docker-machine `$ docker-machine start dev`

`dev` is your docker machine

#### 3.Docker-compose up

```sh
$ docker-compose up
```

### Tips
SSH your docker machine `dev`
```sh
$ docker-machine ssh dev
```

stop your docker-machine `dev`
```sh
$ docker-machine stop dev
```

and to start it again
```sh
$ docker-machine stop dev
```

and DONT forget to set env docker-machine again by run
```sh
$ docker-machine env dev
```

## Thanks to
https://github.com/kasperisager/php-dockerized

http://www.cameronmaske.com/docker-on-osx/
