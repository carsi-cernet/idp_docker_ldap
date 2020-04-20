source /etc/profile
chown -R tomcat.tomcat /opt/shibboleth-idp
chown -R tomcat.tomcat /var/log/tomcat
systemctl restart tomcat