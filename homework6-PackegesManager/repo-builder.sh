#!/bin/bash
sudo su
cd ~
echo "INSTALL SOFTWARE"
yum install -y redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils gcc vim
curl -fsSL https://get.docker.com/ | sh
systemctl start docker

echo "DOWNLOAD RPM"
wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.20.2-1.el7.ngx.src.rpm
wget https://github.com/openssl/openssl/archive/refs/heads/OpenSSL_1_1_1-stable.zip
wget https://downloads.percona.com/downloads/percona-distribution-mysql-ps/percona-distribution-mysql-ps-8.0.28/binary/redhat/8/x86_64/percona-orchestrator-3.2.6-2.el8.x86_64.rpm -O percona-orchestrator-3.2.6-2.el8.x86_64.rpm

echo "PRE-BILD PREPARETION"
unzip  OpenSSL_1_1_1-stable.zip 
mv openssl-OpenSSL_1_1_1-stable openssl-1.1.1a
rm -f /etc/yum.repos.d/CentOS-Sources.repo
echo "RPM DIR PREPARE"
rpm -i ./nginx-1.20.2-1.el7.ngx.src.rpm
#sudo mv /root/rpmbuild ./
ls -l ./rpmbuild/

echo "CHANGE SPEC"
sed -i 's/--with-debug/--with-openssl=\/root\/openssl-1.1.1a/g' ./rpmbuild/SPECS/nginx.spec

echo "INSTALL DEPENDENCES"
yum-builddep ./rpmbuild/SPECS/nginx.spec -y

echo "BILD RPM"
rpmbuild -bb ./rpmbuild/SPECS/nginx.spec

echo "CREATE REPODIR"
mkdir ./repo
cp ./rpmbuild/RPMS/x86_64/nginx-1.20.2-1.el7.ngx.x86_64.rpm ./repo
cp percona-orchestrator-3.2.6-2.el8.x86_64.rpm ./repo
createrepo ./repo 

echo "CREATE DOCKERFILE"
cat >> Dockerfile << EOF
FROM nginx
RUN mkdir -p /usr/share/nginx/html/repo
COPY ./rpmbuild/RPMS/x86_64/nginx-1.20.2-1.el7.ngx.x86_64.rpm /usr/share/nginx/html/repo/nginx-1.20.2-1.el7.ngx.x86_64.rpm
COPY ./repo/ /usr/share/nginx/html/repo/
RUN sed -i 's/index  index.html index.htm;/ index  index.html index.htm;\nautoindex on;/g' /etc/nginx/conf.d/default.conf
EOF

echo "BUILD DOCKERFILE"
docker build -t otus/nginx .
docker run -d -p 80:80 otus/nginx

echo "CREATE REPOFILE"
cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF

yum repolist enabled | grep otus

yum list | grep otus
