# Liferay 6.2
#
# VERSION 0.0.1
#

FROM snasello/docker-debian-java7:7u79

MAINTAINER Ivano Masiero <info@ivanomasiero.com>

ENV JAVA_XMX 2048
ENV JAVA_MAX_PERM_SIZE 512

# install liferay
RUN curl -O -s -k -L -C - http://downloads.sourceforge.net/project/lportal/Liferay%20Portal/6.2.3%20GA4/liferay-portal-tomcat-6.2-ce-ga4-20150416163831865.zip \
	&& unzip liferay-portal-tomcat-6.2-ce-ga4-20150416163831865.zip -d /opt \
	&& rm liferay-portal-tomcat-6.2-ce-ga4-20150416163831865.zip

# config (remote debug enabled)

RUN /bin/echo -e '\nCATALINA_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,address=8000,server=y,suspend=n -Dcom.sun.management.jmxremote.port=1898 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false $CATALINA_OPTS -Xmx${JAVA_XMX}m -XX:MaxPermSize=${JAVA_MAX_PERM_SIZE}m -Dexternal-properties=portal-bd.properties"' >> /opt/liferay-portal-6.2-ce-ga4/tomcat-7.0.42/bin/setenv.sh

# add configuration Liferay file
ADD /portal-bundle.properties /opt/liferay-portal-6.2-ce-ga4/portal-bundle.properties
ADD /portal-bd.properties /opt/liferay-portal-6.2-ce-ga4/portal-bd.properties

# volumes
VOLUME ["/var/liferay-home", "/opt/liferay-portal-6.2-ce-ga4/"]

# Ports
EXPOSE 8080
EXPOSE 8000
EXPOSE 1898

# Set JAVA_HOME
ENV JAVA_HOME /opt/java

# EXEC
CMD ["run"]
ENTRYPOINT ["/opt/liferay-portal-6.2-ce-ga4/tomcat-7.0.42/bin/catalina.sh"]


