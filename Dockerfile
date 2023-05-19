FROM tomcat:8.5.78-jdk8-openjdk-slim-buster

MAINTAINER Axiu <itzyx@vip.qq.com>

ENV TZ PRC

ENV RESTCLOUD_VERSION 2.0

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
	wget -O linux-tomcat.tar.gz "https://www.etlcloud.cn/download/linux-tomcat.tar.gz"; \
	tar zxvf linux-tomcat.tar.gz; \
	rm -rf linux-tomcat.tar.gz /usr/local/tomcat/webapps/*; \
	unzip -d /usr/local/tomcat/webapps/ROOT /usr/local/tomcat/apache-tomcat-8.5.57/webapps/ROOT.war; \
	rm -rf /usr/local/tomcat/apache-tomcat-8.5.57; \
	rm -rf /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/mongodb-driver*



RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY application.properties /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

EXPOSE 8080

CMD ["catalina.sh", "run"]
