FROM nriet/tomcat:8.5-jdk8

MAINTAINER Axiu <itzyx@vip.qq.com>

ENV TZ PRC

ENV RESTCLOUD_WAR_URL https://github.com/nriet/restcloud/releases/download/3.4/RestCloud-ETL-V3.4.war
# ENV RESTCLOUD_WAR_URL http://data.nriet.xyz/RestCloud-ETL-V3.2.war

RUN set -eux && \
	apt-get update && \
	apt-get install -y --no-install-recommends wget unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
	rm -rf /var/cache/apt 

RUN set -eux; \
	\
	wget -O ROOT.war "${RESTCLOUD_WAR_URL}" --no-check-certificate; \
	rm -rf /usr/local/tomcat/webapps/*; \
	unzip -oq ROOT.war -d /usr/local/tomcat/webapps/ROOT; \
	rm -rf ROOT.war 
	
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

EXPOSE 8080 8443

# Start container
CMD ["catalina.sh", "run"]

HEALTHCHECK --interval=60s --timeout=3s \
	CMD curl --fail 'http://localhost:8080/restcloud/view/page/index.html' || exit 1

