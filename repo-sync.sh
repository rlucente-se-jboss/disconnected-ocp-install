#!/usr/bin/env bash

echo
echo "This script must have access to the public internet in order"
echo "to sync the repositories and images."
echo

systemctl stop httpd

# sync the repositories
for repo in \
    rhel-7-server-rpms \
    rhel-7-server-extras-rpms \
    rhel-7-server-ansible-2.4-rpms \
    rhel-7-server-ose-3.10-rpms
do
    reposync --gpgcheck -lm --repoid=${repo} --download_path=/var/www/html/repos
    createrepo -v /var/www/html/repos/${repo} -o /var/www/html/repos/${repo} 
done

# pull the images
for img in $(cat \
    ose3-builder-images.txt \
    ose3-images.txt \
    ose3-logging-metrics-images.txt \
    ose3-service-catalog-broker-images.txt )
do
    docker pull ${img} || exit 1
done

# save all the images
for lst in \
    ose3-builder-images \
    ose3-images \
    ose3-logging-metrics-images \
    ose3-service-catalog-broker-images
do
    docker save -o /var/www/html/repos/images/${lst}.tar $(cat ${lst}.txt) || exit 1
done

chmod -R +r /var/www/html/repos
restorecon -vR /var/www/html

systemctl start httpd

pushd $(dirname $0) &> /dev/null
IP_ADDR=$(ip route get 8.8.8.8 | awk '{print $NF; exit}')
sed -i 's/^\(IP_ADDR=\)..*/\1'$IP_ADDR'/g' install.conf
popd &> /dev/null

echo
echo "The httpd server for offline installations of OCP is at"
echo "$IP_ADDR"
echo

