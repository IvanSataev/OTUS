#!/bin/bash
yum install -y nfs-utils
systemctl enable --now firewalld
echo "192.168.56.110:/var/share/upload /mnt nfs vers=3,proto=udp,noauto,x-systemd.automount 0 0" >> /etc/fstab
systemctl daemon-reload
systemctl restart remote-fs.target
mount | grep mnt