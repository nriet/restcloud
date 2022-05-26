FROM nriet/tomcat:8.5.78-jdk8-openjdk-slim-buster-python3

MAINTAINER Axiu <itzyx@vip.qq.com>

ENV RESTCLOUD_VERSION 1.2.1

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		wget \
		unzip \
	; \
	rm -rf /var/cache/apt 

RUN set -eux; \
	\
	wget -O RestCloud-Update.zip "https://club.restcloud.cn/developers-server/rest/down/download_new?fileName=RestCloud-Update-V${RESTCLOUD_VERSION}.zip&type=3"; \
	unzip RestCloud-Update.zip; \
	rm -rf RestCloud-Update.zip /usr/local/tomcat/conf/context.xml /usr/local/tomcat/webapps/*; \
	unzip -d /usr/local/tomcat/webapps/ROOT /usr/local/tomcat/apache-tomcat-8.5.57/webapps/ROOT.war; \
	cp /usr/local/tomcat/apache-tomcat-8.5.57/conf/context.xml /usr/local/tomcat/conf/; \
	rm -rf /usr/local/tomcat/apache-tomcat-8.5.57

EXPOSE 8080

CMD ["catalina.sh", "run"]
