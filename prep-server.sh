#!/usr/bin/env bash

. $(dirname $0)/install.conf

rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

subscription-manager register --username=$RHSM_USER --password=$RHSM_PASS

# if POOL_ID not set, this will look for associated Employee SKU
if [ -z "$POOL_ID" ]
then
    POOL_ID=$(subscription-manager list --all --available | \
        grep '^Subscription Name:\|^Pool ID:\|^System Type:' | \
        grep -A2 'Employee SKU' | grep -B2 Virtual | grep 'Pool ID:' | \
        awk '{print $NF; exit}')
fi

subscription-manager attach --pool=$POOL_ID
subscription-manager repos \
    --enable=rhel-7-server-rpms \
    --enable=rhel-7-server-extras-rpms \
    --enable=rhel-7-server-ansible-2.4-rpms \
    --enable=rhel-7-server-ose-3.10-rpms

yum -y install yum-utils createrepo docker git httpd
yum -y update
yum -y clean all && rm -fr /var/cache/yum

mkdir -p /var/www/html/repos/images

firewall-cmd --permanent --add-service=http

systemctl enable docker httpd
systemctl reboot

