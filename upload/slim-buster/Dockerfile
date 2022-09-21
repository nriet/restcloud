FROM nriet/restcloud:1.6.0-slim-buster

MAINTAINER Axiu <itzyx@vip.qq.com>

USER root

ENV RESTCLOUD_VERSION 1.6.1



RUN set -eux; \
	\
	wget -O RestCloud-Update.zip "https://club.restcloud.cn/developers-server/rest/down/download_new?fileName=RestCloud-Update-V${RESTCLOUD_VERSION}.zip&type=3"; \
	unzip -d /tmp/RestCloud-Update RestCloud-Update.zip; \
	rm -rf RestCloud-Update.zip \
	/usr/local/tomcat/webapps/ROOT/WEB-INF/lib/restcloud-* \
	; \
	cp -rf /tmp/RestCloud-Update/initdata/* /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/initdata/; \
	cp -rf /tmp/RestCloud-Update/lib/* /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/; \
	rm -rf /tmp/RestCloud-Update 

ADD restcloud-etlcore-1.4.0.jar /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/

EXPOSE 8080

CMD ["catalina.sh", "run"]
