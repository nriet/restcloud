FROM nriet/tomcat:8.5.78-jdk8-openjdk-slim-buster-python3

MAINTAINER Axiu <itzyx@vip.qq.com>

ENV RESTCLOUD_VERSION 2.0

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		net-tools \
		wget \
	; \
	rm -rf /var/cache/apt 

RUN set -eux; \
	\
	wget -O linux-tomcat.tar.gz "https://www.etlcloud.cn/download/linux-tomcat.tar.gz"; \
	tar zxvf linux-tomcat.tar.gz; \
	rm -rf linux-tomcat.tar.gz /usr/local/tomcat/webapps/*; \
	mv tomcat/webapps/ROOT /usr/local/tomcat/webapps; \
	rm -rf tomcat
	
COPY application.properties /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/


EXPOSE 8080

CMD ["catalina.sh", "run"]
