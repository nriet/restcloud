FROM nriet/restcloud:1.6.0-slim-buster-python3-fj

MAINTAINER Axiu <itzyx@vip.qq.com>

USER root

ENV RESTCLOUD_VERSION 1.6.1

RUN set -eux; \
	\
	rm -rf /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/restcloud-* 

COPY RestCloud-Update-V${RESTCLOUD_VERSION}/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

EXPOSE 8080

CMD ["catalina.sh", "run"]
