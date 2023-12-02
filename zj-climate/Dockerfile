FROM nriet/restcloud:2.8-slim-buster-python3

MAINTAINER Axiu <itzyx@vip.qq.com>

# ENV NWP_PL_VERSION 1.0
# COPY application.properties /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/
# COPY app.tar.gz /
COPY lib/* /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/

#解决Java jdbc连不上Sqlserver问题，TLS版本
COPY java.security /usr/local/openjdk-8/jre/lib/security/
# ENV GRIB_DEFINITION_PATH /app/NWP_PL_V${NWP_PL_VERSION}/definitions

# ENV LD_LIBRARY_PATH :/app/NWP_PL_V${NWP_PL_VERSION}/lib

# RUN apt-get update \
#       && apt-get install -y --no-install-recommends \
#         gdal-bin libgdal-dev libnetcdf-dev postgresql-client postgis; \
#     rm -rf /var/lib/apt/lists/*

RUN apt-get update \
      && apt-get install -y --no-install-recommends \
        curl; \
    rm -rf /var/lib/apt/lists/*

#timescaledb认证文件
# COPY .pgpass /root/
# RUN set -eux; \
# 	\
# 	chmod 600 /root/.pgpass /; \
# 	tar zxvf /app.tar.gz -C /; \
# 	rm -rf /app.tar.gz
#下载EC认证文件，用于人工智能算法
#https://cds.climate.copernicus.eu/cdsapp#!/dataset/reanalysis-era5-single-levels?tab=form
# COPY .cdsapirc /root/
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8080

CMD ["catalina.sh", "run"]
