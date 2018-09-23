#!/usr/bin/env bash

. $(dirname $0)/install.conf

for host in ${OCP_HOST_IPS[@]}
do
    for list in ose3-builder-images ose3-images \
        ose3-logging-metrics-images ose3-service-catalog-broker-images
    do
        echo "Enter root password for host $host when prompted"
        scp /var/www/html/repos/images/${list}.tar root@${host}:

        echo "Enter root password for host $host when prompted"
        ssh root@${host} "docker load -i ${list}.tar"
    done
done

