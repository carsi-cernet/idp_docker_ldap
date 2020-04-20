FROM centos:7
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]

COPY idp3config /opt/inst/idp3config/

RUN yum -y install mod_ssl java-1.8.0-openjdk java-1.8.0-openjdk-devel tomcat wget crontabs;\
echo "" >> /etc/profile; \
echo "export JAVA_HOME=/etc/alternatives/java_sdk_1.8.0" >> /etc/profile; \
echo "export PATH=$PATH:$JAVA_HOME/bin" >> /etc/profile; \
echo "export CLASSPATH=.:$JAVA_HOME/jre/lib:$JAVA_HOME/lib:$JAVA_HOME/lib/tools.jar" >> /etc/profile; \
source /etc/profile; \
cp -f /opt/inst/idp3config/idp.xml /etc/tomcat/Catalina/localhost/idp.xml; \
cp -f /opt/inst/idp3config/server.xml /etc/tomcat/server.xml; \
cp -f /opt/inst/idp3config/javax.servlet.jsp.jstl-api-1.2.1.jar /usr/share/tomcat/lib/javax.servlet.jsp.jstl-api-1.2.1.jar; \
cp -f /opt/inst/idp3config/javax.servlet.jsp.jstl-1.2.1.jar /usr/share/tomcat/lib/javax.servlet.jsp.jstl-1.2.1.jar; \
rm -rf /opt/inst/idp3config/shibboleth-identity-provider-3.4.6/; \
cd /opt/inst/idp3config/; \
tar xzf shibboleth-identity-provider-3.4.6.tar.gz; \
cd shibboleth-identity-provider-3.4.6; \
./bin/install.sh -Didp.noprompt=true -Didp.property.file=/opt/inst/idp3config/idp.installer.properties; \
openssl pkcs12 -in /opt/shibboleth-idp/credentials/idp-backchannel.p12 -out /opt/shibboleth-idp/credentials/idp-backchannel.key -nocerts -nodes -password pass:'changeit' ; \
cp -f /opt/inst/idp3config/metadata-providers-pre.xml /opt/shibboleth-idp/conf/metadata-providers.xml; \
cp -f /opt/inst/idp3config/attribute-resolver.xml /opt/shibboleth-idp/conf/attribute-resolver.xml; \
randkey=`openssl rand 32 -base64`; \
sed -i "s/xxxxxxxxxxxxxxxxxxxx/$randkey/g" /opt/shibboleth-idp/conf/attribute-resolver.xml; \
cp -f /opt/inst/idp3config/ldap.properties /opt/shibboleth-idp/conf/ldap.properties; \
cp -f /opt/inst/idp3config/audit.xml /opt/shibboleth-idp/conf/audit.xml; \
cp -f /opt/inst/idp3config/consent-intercept-config.xml /opt/shibboleth-idp/conf/intercept/consent-intercept-config.xml; \
cp -f /opt/inst/idp3config/relying-party.xml /opt/shibboleth-idp/conf/relying-party.xml; \
cp -f /opt/inst/idp3config/attribute-filter.xml /opt/shibboleth-idp/conf/attribute-filter.xml; \
cp -f /opt/inst/idp3config/password-authn-config.xml /opt/shibboleth-idp/conf/authn/password-authn-config.xml; \
cp -f /opt/inst/idp3config/dsmeta.pem /opt/shibboleth-idp/credentials/; \
sed -i "s/#idp.consent.allowPerAttribute = false/idp.consent.allowPerAttribute = true/g" /opt/shibboleth-idp/conf/idp.properties; \
wget -P /opt/shibboleth-idp/metadata/ https://dspre.carsi.edu.cn/carsifed-metadata-pre.xml; \
chown -R tomcat.tomcat /opt/shibboleth-idp; \
systemctl enable tomcat.service;

CMD ["/usr/sbin/init"]