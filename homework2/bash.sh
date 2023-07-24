#!/bin/bash

lsblk
echo "LSBLK END"
sleep 3

sudo fdisk -l
echo "FDISK END"
sleep 3

echo "NULLIFY SUPERBLOCK"
mdadm --zero-superblock --force /dev/sd{b,c,d,e,f}
mdadm --create --verbose /dev/md128 -l 6 -n 5 /dev/sd{b,c,d,e,f}
cat /proc/mdstat

echo "CREATE MDADM.CONF"
echo "DEVICE partitions" > /etc/mdadm.conf
mdadm --detail --scan --verbose | awk '/ARRAY/{print}' >> /etc/mdadm.conf

echo "BREAKING SDE"
mdadm /dev/md128 --fail /dev/sde
cat /proc/mdstat
sleep 3

mdadm -D /dev/md128

echo "REMOVE SDE"
mdadm /dev/md128 --remove /dev/sde
cat /proc/mdstat
sleep 3

echo "ADD SDE"
mdadm /dev/md128 --add /dev/sde
cat /proc/mdstat
sleep 15
cat /proc/mdstat

echo "CREATE GPT"
parted -s /dev/md128 mklabel gpt

echo "CREATE PARTITION"
parted /dev/md128 mkpart primary ext4 0% 20%
parted /dev/md128 mkpart primary ext4 20% 40%
parted /dev/md128 mkpart primary ext4 40% 60%
parted /dev/md128 mkpart primary ext4 60% 80%
parted /dev/md128 mkpart primary ext4 80% 100%

echo "FORMAT PARTITION"
for i in $(seq 1 5);do sudo mkfs.ext4 /dev/md128p$i; done
sudo mkdir /mnt/part{1,2,3,4,5}

echo "MOUNT"
for i in $(seq 1 5);do mount  /dev/md128p$i /mnt/part$i; done
ls -Rl /mnt/
