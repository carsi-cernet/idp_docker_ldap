#open firewall 80 and 443
firewall-cmd --add-service=http --permanent
firewall-cmd --add-service=https --permanent
firewall-cmd --reload

#install docker and docker-compose
yum -y install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum -y install docker-ce docker-ce-cli containerd.io
systemctl start docker
curl -L "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

#sync time
yum -y install ntp
timedatectl set-timezone Asia/Shanghai
sed -i "s/server 0.centos.pool.ntp.org iburst/server ntp.aliyun.com/g" /etc/ntp.conf
sed -i "s/server 1.centos.pool.ntp.org iburst/#server 1.centos.pool.ntp.org iburst/g" /etc/ntp.conf
sed -i "s/server 2.centos.pool.ntp.org iburst/#server 2.centos.pool.ntp.org iburst/g" /etc/ntp.conf
sed -i "s/server 3.centos.pool.ntp.org iburst/#server 3.centos.pool.ntp.org iburst/g" /etc/ntp.conf
systemctl enable ntpd.service
systemctl restart ntpd

#add cron to get log
echo "0 */1 * * * sh /opt/idp_docker_ldap/auditlog.sh >/dev/null 2>&1" >> /var/spool/cron/root