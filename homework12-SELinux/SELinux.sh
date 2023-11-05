#install epel-release
yum install -y epel-release
#install nginx
yum install -y nginx setools-console policycoreutils-python vim
#change nginx port
sed -ie 's/:80/:4881/g' /etc/nginx/nginx.conf
sed -i 's/listen       80;/listen       4881;/' /etc/nginx/nginx.conf
#disable SELinux
#setenforce 0
#start nginx
systemctl start nginx
systemctl status nginx

echo "CHECK PORT NGINX"
ss -tlpn | grep 4881 
echo "CHECK NGINX CONFIGURE"
nginx - t
echo "CHECK STATUS FIREWALLD"
systemctl status firewalld
echo "CHECK STATUS SELINUX"
getenforce

echo "FIRST WAY TO OPEN  THE PORT "
grep nginx /var/log/audit/audit.log | audit2why
setsebool -P nis_enabled on
systemctl restart nginx
systemctl status nginx
curl http://127.0.0.1:4881

getsebool -a | grep nis_enabled
#switch value nis_enabled to off
setsebool -P nis_enabled off
systemctl restart nginx

echo "SECOND WAY TO OPEN  THE PORT"
semanage port -l | grep http
semanage port -a -t http_port_t -p tcp 4881
semanage port -l | grep  http_port_t
systemctl restart nginx
systemctl status nginx
curl http://127.0.0.1:4881
#delete port from seemanage
semanage port -d -t http_port_t -p tcp 4881
semanage port -l | grep  http_port_t
systemctl restart nginx
systemctl status nginx

echo "THIRD WAY TO OPEN  THE PORT"
grep nginx /var/log/audit/audit.log | audit2allow -M nginx
semodule -i nginx.pp
semodule -l
#remove module
semodule -r nginx