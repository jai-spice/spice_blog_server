#!/bin/sh

docker build . -t myserver;

container_ids=$(docker ps -a -q --filter ancestor=myserver);

if [[ ! -z "$container_ids" ]] 
    then 
        for container_id in $container_ids
        do
            docker stop $container_id
            docker rm -f $container_id
        done
fi

docker run -it -p 8080:8080 myserver;