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
	wget -O RestCloud-Linux.zip "https://club.restcloud.cn/developers-server/rest/down/download_new?fileName=RestCloud-Linux-V${RESTCLOUD_VERSION}.zip&type=2"; \
	unzip RestCloud-Linux.zip; \
	rm -rf RestCloud-Linux.zip /usr/local/tomcat/conf/context.xml /usr/local/tomcat/webapps/*; \
	unzip -d /usr/local/tomcat/apache-tomcat-8.5.57/webapps/ROOT /usr/local/tomcat/webapps/ROOT.war; \
	rm -rf /usr/local/tomcat/apache-tomcat-8.5.57
	
COPY context.xml /usr/local/tomcat/conf/

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8080

CMD ["catalina.sh", "run"]
