FROM nriet/tomcat:8.5.78-jdk8-openjdk-slim-buster-python3

MAINTAINER Axiu <itzyx@vip.qq.com>

ENV TZ PRC

ENV RESTCLOUD_VERSION 2.2

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		net-tools \
		wget \
	; \
	rm -rf /var/cache/apt 
 
RUN set -eux; \
	\
	wget -O linux-tomcat.tar "https://etl.restcloud.cn/download/linux-tomcat.tar"; \
	tar xvf linux-tomcat.tar; \
	rm -rf linux-tomcat.tar /usr/local/tomcat/webapps/*; \
	mv tomcat/webapps/ROOT /usr/local/tomcat/webapps; \
	rm -rf tomcat


RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY application.properties /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

EXPOSE 8080

CMD ["catalina.sh", "run"]
