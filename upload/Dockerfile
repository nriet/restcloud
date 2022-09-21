FROM nriet/restcloud

MAINTAINER Axiu <itzyx@vip.qq.com>

ENV RESTCLOUD_VERSION 1.6.1

RUN set -eux; \
	\
	/usr/local/tomcat/webapps/ROOT/WEB-INF/lib/restcloud-* 

COPY RestCloud-Update-V${RESTCLOUD_VERSION}/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

EXPOSE 8080

CMD ["catalina.sh", "run"]
