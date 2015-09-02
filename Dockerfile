# Liferay 6.2
#
# VERSION 0.0.1
#

FROM snasello/docker-debian-java7:7u79

MAINTAINER Ivano Masiero <info@ivanomasiero.com>

ENV TERM=xterm

# install liferay
RUN curl -O -s -k -L -C - http://downloads.sourceforge.net/project/lportal/Liferay%20Portal/6.2.3%20GA4/liferay-portal-tomcat-6.2-ce-ga4-20150416163831865.zip \
	&& unzip liferay-portal-tomcat-6.2-ce-ga4-20150416163831865.zip -d /opt \
	&& rm liferay-portal-tomcat-6.2-ce-ga4-20150416163831865.zip

# config (remote debug enabled)

# install nano as builtin editor
RUN apt-get update && apt-get install -y nano

RUN /bin/echo -e '\nCATALINA_OPTS="$CATALINA_OPTS -Dexternal-properties=portal-postgres.properties"' >> /opt/liferay-portal-6.2-ce-ga4/tomcat-7.0.42/bin/setenv.sh

# add configuration Liferay file
ADD /portal-bundle.properties /opt/liferay-portal-6.2-ce-ga4/portal-bundle.properties
ADD /portal-postgres.properties /opt/liferay-portal-6.2-ce-ga4/portal-postgres.properties

# add Remote IDE Connector CE 2.0.1 portlet (for remote debugging)
ADD ["/portlets/Remote IDE Connector CE.lpkg", "/opt/liferay-portal-6.2-ce-ga4/deploy/Remote IDE Connector CE.lpkg"]

# volumes
VOLUME ["/var/liferay-home", "/opt/liferay-portal-6.2-ce-ga4/"]

# Ports
EXPOSE 8080

# Set JAVA_HOME
ENV JAVA_HOME /opt/java

# EXEC
CMD ["run"]
ENTRYPOINT ["/opt/liferay-portal-6.2-ce-ga4/tomcat-7.0.42/bin/catalina.sh"]


