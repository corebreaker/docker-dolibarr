#! /bin/sh
cd `dirname $0`

case $1 in
build)
    docker build -t corebreaker.dolibarr/dolibarr:latest . ;;

create)
    docker volume create --name dolibarr-socket
    docker volume create --name dolibarr-db
    docker volume create --name dolibarr-data
    docker run -d --name dolibarr.db -v dolibarr-socket:/var/run/mysqld:nocopy -v dolibarr-db:/var/lib/mysql -p 2222:22 corebreaker.dolibarr/dolibarr:latest db
    docker run -d --name dolibarr.www -v dolibarr-socket:/var/run/mysqld:nocopy -v dolibarr-data:/var/lib/dolibarr -p 80 dolibarr:run
    ;;

start)
    docker start dolibarr.db
    docker start dolibarr.www
    ;;

start)
    docker start dolibarr.db
    docker start dolibarr.www
    ;;

*)
    echo "Usage: $0 start|stop|build|create" ;;
esac
