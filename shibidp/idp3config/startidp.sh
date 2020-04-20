source /etc/profile
timedatectl set-timezone Asia/Shanghai
chown -R tomcat.tomcat /opt/shibboleth-idp
chown -R tomcat.tomcat /var/log/tomcat
systemctl restart tomcat