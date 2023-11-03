sudo -i
### login by password
sed -i 's/^PasswordAuthentication.*$/PasswordAuthentication yes/' /etc/ssh/sshd_config
### create test user
useradd otusadm
useradd otus
echo "test" |  passwd --stdin otusadm && echo "test" | passwd --stdin otus

groupadd -f admin
### adding to group admin 
usermod otusadm -a -G admin
usermod root -a -G admin 
usermod vagrant -a -G admin
### script for limitation
cat >> /usr/local/bin/login.sh << EOF
#!/bin/bash
#Первое условие: если день недели суббота или воскресенье
if [ \$(date +%a) = "Sat" ] || [ \$(date +%a) = "Sun" ]; then
 #Второе условие: входит ли пользователь в группу admin
 if \$(getent group admin | grep -qw "\$PAM_USER"); then
    #Если пользователь входит в группу admin, то он может подключиться
     exit 0
 else
    #Иначе ошибка (не сможет подключиться)
    exit 1
 fi
  #Если день не выходной, то подключиться может любой пользователь
else
    exit 0
fi

EOF

chmod +x /usr/local/bin/login.sh
### set saturday
date 11042023
### adding pam config
sed -i 's/pam_nologin.so/pam_nologin.so\n account    required  pam_exec.so \/usr\/local\/bin\/login.sh/g' /etc/pam.d/sshd
systemctl restart sshd.service