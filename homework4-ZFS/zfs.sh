sudo -i
#install zfs repo
yum install -y http://download.zfsonlinux.org/epel/zfs-release.el7_8.noarch.rpm
#import gpg key 
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-zfsonlinux
#install DKMS style packages for correct work ZFS
yum install -y epel-release kernel-devel zfs
#change ZFS repo
yum-config-manager --disable zfs
yum-config-manager --enable zfs-kmod
yum install -y zfs
#Add kernel module zfs
modprobe zfs
#install wget
yum install -y wget vim

### difine an algoritm with best compression
zpool create otus1 mirror /dev/sdb /dev/sdc
zpool create otus2 mirror /dev/sdd /dev/sde
zpool create otus3 mirror /dev/sdf /dev/sdg
zpool create otus4 mirror /dev/sdh /dev/sdi

zpool list

zfs set compression=lzjb otus1
zfs set compression=lz4 otus2
zfs set compression=gzip-9 otus3
zfs set compression=zle otus4

zfs get all | grep compression

for i in {1..4}; do wget -P /otus$i https://www.gutenberg.org/cache/epub/2600/pg2600.txt --no-check-certificate; done

ls -l /otus*

zfs list

zfs get all | grep compressratio | grep -v ref

echo "max value compressratio on otus3 => gzip-9 best compression"
### define pool settings
wget -O archive.tar.gz --no-check-certificate 'https://drive.google.com/u/0/uc?id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg&export=download' 
tar -xzvf archive.tar.gz

zpool import -d zpoolexport/

zpool import -d zpoolexport/ otus
zpool status

echo "size pool"
zfs get available otus
echo "type pool"
zfs get readonly otus
echo "value recordsize"
zfs get recordsize otus
echo "type compression"
zfs get compression otus
echo "checksum"
zfs get checksum otus

### find a message from teacher
wget -O otus_task2.file --no-check-certificate "https://drive.google.com/u/0/uc?id=1gH8gCL9y7Nd5Ti3IRmplZPF1XjzxeRAG&export=download"
zfs receive otus/test@today < otus_task2.file
echo "find message"
find /otus/test/ -name "*secret*"
echo "print message"
cat /otus/test/task1/file_mess/secret_message
