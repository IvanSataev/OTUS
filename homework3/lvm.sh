### pre-install
sudo -i
mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh
yum install -y mdadm smartmontools hdparm gdisk vim xfsdump


### mirror on var
pvcreate /dev/sdd /dev/sde
vgcreate vg_var /dev/sdd /dev/sde
lvcreate -L 950M -m1 -n lv_var vg_var
mkfs.ext4 /dev/vg_var/lv_var
mount /dev/vg_var/lv_var /mnt
cp -aR /var/* /mnt/
umount /mnt
mount /dev/vg_var/lv_var /var
echo "LSBLK LIST"
lsblk
echo "`blkid | grep var: | awk '{print $2}'` /var ext4 defaults 0 0" >> /etc/fstab


### snap on home
pvcreate /dev/sdb
vgcreate vg01 /dev/sdb
lvcreate -L 1900M -n home /dev/vg01
mkfs.xfs /dev/mapper/vg01-home
mount /dev/vg01/home /mnt/
cp -aR /home/* /mnt/
rm -rf /home/*
umount /mnt
mount /dev/vg01/home /home/
echo "`blkid | grep home | awk '{print $2}'` /home xfs defaults 0 0" >> /etc/fstab
touch /home/file{1..20}
echo "LIST FILES FROM HOME"
ls -l /home
lvcreate -L 100MB -s -n home_snap /dev/mapper/vg01-home
rm -f /home/file{11..20}
echo "LIST FILES FROM HOME AFTER REMOVE"
ls -l /home
umount /home -l
lvconvert --merge /dev/vg01/home_snap
mount /home
echo "LIST FILES FROM HOME AFTER MERGE SNAP"
ls -l /home

### reduce root
### create  temporary lvm for root
cd /
pvcreate /dev/sdc
vgcreate vg_root /dev/sdc
lvcreate -n lv_root -l +100%FREE /dev/vg_root
mkfs.xfs /dev/vg_root/lv_root
mount /dev/vg_root/lv_root /mnt
sudo xfsdump -J - /dev/VolGroup00/LogVol00 |sudo xfsrestore -J - /mnt

for i in /proc/ /sys/ /dev/ /run/ /boot/; do mount --bind $i /mnt$i; done
chroot /mnt/ /bin/bash <<"EOT"
grub2-mkconfig -o /boot/grub2/grub.cfg
cd /boot 
for i in `ls initramfs-*img`; do dracut -v $i `echo $i|sed "s/initramfs-//g;s/.img//g"` --force; done
sed -i 's/rd\.lvm\.lv=VolGroup00\/LogVol00/rd\.lvm\.lv=vg_root\/lv_root/g' /boot/grub2/grub.cfg
EOT
