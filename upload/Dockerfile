FROM nriet/restcloud

MAINTAINER Axiu <itzyx@vip.qq.com>

ENV RESTCLOUD_VERSION 1.6.0

RUN set -eux; \
	\
	wget -O RestCloud-Update.zip "https://club.restcloud.cn/developers-server/rest/down/download_new?fileName=RestCloud-Update-V${RESTCLOUD_VERSION}.zip&type=3"; \
	unzip -d /tmp/RestCloud-Update RestCloud-Update.zip; \
	rm -rf RestCloud-Update.zip \
	/usr/local/tomcat/webapps/ROOT/WEB-INF/lib/restcloud-* \
	/usr/local/tomcat/webapps/ROOT/WEB-INF/classes/static/res \
	; \
	cp -r /tmp/RestCloud-Update/static/res /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/static/; \
	cp -r /tmp/RestCloud-Update/lib/restcloud-* /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/; \
	rm -rf /tmp/RestCloud-Update 


EXPOSE 8080

CMD ["catalina.sh", "run"]
