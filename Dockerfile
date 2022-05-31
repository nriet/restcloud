FROM nriet/tomcat:8.5.79-jdk8-openjdk-slim-buster-python3

MAINTAINER Axiu <itzyx@vip.qq.com>

ENV RESTCLOUD_VERSION 1.3.0

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		wget \
		unzip \
	; \
	rm -rf /var/cache/apt 

RUN set -eux; \
	\
	wget -O RestCloud-Linux.zip "https://club.restcloud.cn/developers-server/rest/down/download_new?fileName=RestCloud-Linux-V${RESTCLOUD_VERSION}.zip&type=2"; \
	unzip RestCloud-Linux.zip; \
	rm -rf RestCloud-Linux.zip /usr/local/tomcat/conf/context.xml /usr/local/tomcat/webapps/*; \
	unzip -d /usr/local/tomcat/webapps/ROOT /usr/local/tomcat/apache-tomcat-8.5.57/webapps/ROOT.war; \
	cp /usr/local/tomcat/apache-tomcat-8.5.57/conf/context.xml /usr/local/tomcat/conf/; \
	rm -rf /usr/local/tomcat/apache-tomcat-8.5.57

COPY application.properties /usr/local/tomcat/apache-tomcat-8.5.57/webapps/ROOT/WEB-INF/classes/

EXPOSE 8080

CMD ["catalina.sh", "run"]
