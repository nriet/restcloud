FROM tomcat:8.5.78-jdk8-openjdk-slim-buster

MAINTAINER Axiu <itzyx@vip.qq.com>

ENV TZ PRC

ENV RESTCLOUD_VERSION 1.3.0

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		net-tools \
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

COPY application.properties /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/


RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

EXPOSE 8080

CMD ["catalina.sh", "run"]
