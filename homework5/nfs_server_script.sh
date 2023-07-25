#!/bin/bash
yum install -y nfs-utils
systemctl enable --now firewalld
firewall-cmd --add-service "nfs3" --add-service "rpc-bind" --add-service "mountd" --permanent
firewall-cmd --reload
systemctl enable --now nfs
mkdir -p /var/share/upload
chown -R nfsnobody:nfsnobody /var/share/upload
chmod 777 /var/share/upload
echo "/var/share/upload 192.168.56.111/32(rw,sync,root_squash)" > /etc/exports
exportfs -r
exportfs -s 


