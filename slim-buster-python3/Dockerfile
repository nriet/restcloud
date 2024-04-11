FROM nriet/tomcat:8.5.78-jdk8-openjdk-slim-buster-python3

MAINTAINER Axiu <itzyx@vip.qq.com>

ENV TZ PRC

ENV RESTCLOUD_VERSION 3.2


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
	wget -O ROOT.war "https://etl.restcloud.cn/download/RestCloud-ETL-V${RESTCLOUD_VERSION}.war" --no-check-certificate; \
	rm -rf /usr/local/tomcat/webapps/*; \
	unzip -oq ROOT.war -d /usr/local/tomcat/webapps/ROOT; \
	rm -rf ROOT.war 


RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#COPY application.properties /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

EXPOSE 8080

CMD ["catalina.sh", "run"]
