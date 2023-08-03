sudo su
yum install -y vim epel-release && rm -f /etc/yum.repos.d/epel-testing.repo && yum install -y spawn-fcgi php php-cli mod_fcgid httpd 
systemctl stop firewalld
setenforce 0
cat >> /etc/sysconfig/watchlog << EOF
WORD=ALERT
LOG=/var/log/watchlog.log
EOF
cat >> /var/log/watchlog.log << EOF
message ALERT 
ALERT
EOF
cat >> /etc/systemd/system/watchlog.service << EOF
[Unit]
Description= My watchlog service

[Service]
Type=oneshot
EnvironmentFile=/etc/sysconfig/watchlog
ExecStart=/opt/watchlog.sh \$WORD \$LOG
EOF
cat >> /etc/systemd/system/watchlog.timer << EOF
[Unit]
Description=Run watch scripts everi 30 sec

[Timer]
OnUnitActiveSec=30
Unit=watchlog.service

[Install]
WantedBy=multi-user.target
EOF
cat >> /opt/watchlog.sh << EOF
#!/bin/bash

WORD=\$1
LOG=\$2
DATE=\`date\`
if grep \$WORD \$LOG &> /dev/null
then
logger "\$DATE: I found word, Master!"
else
exit 0
fi
EOF

chmod +x /opt/watchlog.sh

systemctl daemon-reload
systemctl start watchlog.service
systemctl start watchlog.timer 

echo "LOG MESSAGES"
cat /var/log/messages |grep 'I found word' 


cat >> /etc/systemd/system/spawn-fcgi.service << EOF

[Unit]
Description=Spawn-fcgi startup service by OTUS
After=network.target

[Service]
Type=simple
PIDFile=/var/run/spawn-fcgi.pid
EnvironmentFile=/etc/sysconfig/spawn-fcgi
ExecStart=/usr/bin/spawn-fcgi -n \$OPTIONS
KillMode=process

[Install]
WantedBy=multi-user.target
EOF
sed -i 's/#SOCKET/SOCKET/g' /etc/sysconfig/spawn-fcgi
sed -i 's/#OPTION/OPTION/g' /etc/sysconfig/spawn-fcgi

systemctl daemon-reload
systemctl start spawn-fcgi.service
systemctl status spawn-fcgi.service

echo "OPTIONS=-f conf/first.conf" > /etc/sysconfig/httpd-first
echo "OPTIONS=-f conf/second.conf" > /etc/sysconfig/httpd-second

cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/first.conf
cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/second.conf
sed -i 's/Listen 80/PidFile \/var\/run\/httpd-first.pid\nListen 8080/g' /etc/httpd/conf/first.conf
sed -i 's/Listen 80/PidFile \/var\/run\/httpd-second.pid\nListen 8081/g' /etc/httpd/conf/second.conf
cp /usr/lib/systemd/system/httpd.service /usr/lib/systemd/system/httpd@.service

sed -i 's/EnvironmentFile=\/etc\/sysconfig\/httpd/EnvironmentFile=\/etc\/sysconfig\/httpd-%I/g' /usr/lib/systemd/system/httpd@.service

systemctl daemon-reload
systemctl start httpd@first
systemctl start httpd@second
systemctl status httpd@first
systemctl status httpd@second
