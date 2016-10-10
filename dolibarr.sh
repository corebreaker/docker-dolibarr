#! /bin/sh
cd `dirname $0`

case $1 in
build)
    docker build -t corebreaker/docker-dolibarr:latest . ;;

pull)
    docker pull corebreaker/docker-dolibarr ;;

create)
    docker volume create --name dolibarr-socket
    docker volume create --name dolibarr-db
    docker volume create --name dolibarr-data
    docker run -d --name dolibarr.db \
        -v dolibarr-socket:/var/run/mysqld:nocopy \
        -v dolibarr-db:/var/lib/mysql \
        corebreaker/docker-dolibarr:latest db
    docker run -d --name dolibarr.www \
        -v dolibarr-socket:/var/run/mysqld:nocopy \
        -v dolibarr-data:/var/lib/dolibarr \
        -p 8080 corebreaker/docker-dolibarr:run
    ;;

start)
    docker start dolibarr.db
    docker start dolibarr.www
    ;;

stop)
    docker start dolibarr.www
    docker start dolibarr.db
    ;;

*)
    echo "Usage: $0 start|stop|build|create" ;;
esac
