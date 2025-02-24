FROM nriet/tomcat:8.5-jdk8

MAINTAINER Axiu <itzyx@vip.qq.com>

ENV TZ PRC
ENV CATALINA_HOME /usr/local/tomcat
ENV UNZIP_DISABLE_ZIPBOMB_DETECTION TRUE
ENV RESTCLOUD_WAR_URL https://github.com/nriet/restcloud/releases/download/3.9/RestCloud-ETL-V3.9.zip
# ENV RESTCLOUD_WAR_URL http://data.nriet.xyz/RestCloud-ETL-V3.2.war

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install necessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends vim build-essential libhdf5-dev zlib1g-dev libnetcdf-dev libcurl4-openssl-dev zip unzip && \
    # Cleanup
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    # Eliminate default web applications
    rm -rf ${CATALINA_HOME}/webapps/* && \
    rm -rf ${CATALINA_HOME}/webapps.dist && \
    # restcloud
    curl -fSL "${RESTCLOUD_WAR_URL}" -o ROOT.zip && \
    unzip ROOT.zip -d ${CATALINA_HOME}/webapps/ && \
    mv ${CATALINA_HOME}/webapps/RestCloud-ETL-V3.8 ${CATALINA_HOME}/webapps/ROOT && \
    rm -f ROOT.zip

EXPOSE 8080 8443

# Start container
CMD ["catalina.sh", "run"]

HEALTHCHECK --interval=60s --timeout=3s \
	CMD curl --fail 'http://localhost:8080/restcloud/view/page/index.html' || exit 1

