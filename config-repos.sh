#!/usr/bin/env bash

. $(dirname $0)/install.conf

cat > ose.repo <<EOF1
[rhel-7-server-rpms]
name=rhel-7-server-rpms
baseurl=http://$IP_ADDR/repos/rhel-7-server-rpms 
enabled=1
gpgcheck=0
[rhel-7-server-extras-rpms]
name=rhel-7-server-extras-rpms
baseurl=http://$IP_ADDR/repos/rhel-7-server-extras-rpms 
enabled=1
gpgcheck=0
[rhel-7-server-ansible-2.4-rpms]
name=rhel-7-server-ansible-2.4-rpms
baseurl=http://$IP_ADDR/repos/rhel-7-server-ansible-2.4-rpms 
enabled=1
gpgcheck=0
[rhel-7-server-ose-3.10-rpms]
name=rhel-7-server-ose-3.10-rpms
baseurl=http://$IP_ADDR/repos/rhel-7-server-ose-3.10-rpms 
enabled=1
gpgcheck=0
EOF1

for host in ${OCP_HOST_IPS[@]}
do
    echo "Enter root password for host $host when prompted"
    scp ose.repo root@${host}:/etc/yum.repos.d
done

