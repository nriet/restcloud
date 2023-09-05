FROM nriet/restcloud:2.4-slim-buster

MAINTAINER Axiu <itzyx@vip.qq.com>

COPY application.properties /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

COPY lib/* /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/

# RUN apt-get update \
#       && apt-get install -y --no-install-recommends \
#         gdal-bin libgdal-dev libnetcdf-dev postgresql-client postgis; \
#     rm -rf /var/lib/apt/lists/*


EXPOSE 8080

CMD ["catalina.sh", "run"]
