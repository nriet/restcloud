FROM nriet/restcloud:2.4-slim-buster-python3

MAINTAINER Axiu <itzyx@vip.qq.com>

ENV NWP_PL_VERSION 1.0
COPY application.properties /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/
COPY app.tar.gz /
COPY lib/* /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/
ENV GRIB_DEFINITION_PATH /app/NWP_PL_V${NWP_PL_VERSION}/definitions

ENV LD_LIBRARY_PATH :/app/NWP_PL_V${NWP_PL_VERSION}/lib

RUN apt-get update \
      && apt-get install -y --no-install-recommends \
        gdal-bin libgdal-dev libnetcdf-dev postgresql-client postgis; \
    rm -rf /var/lib/apt/lists/*

#timescaledb认证文件
COPY .pgpass /root/

RUN set -eux; \
	\
	chmod 600 /root/.pgpass /; \
	tar zxvf /app.tar.gz -C /; \
	rm -rf /app.tar.gz


COPY requirements.txt ./

#下载Era5认证文件
#https://cds.climate.copernicus.eu/cdsapp#!/dataset/reanalysis-era5-single-levels?tab=form
COPY .cdsapirc /root/

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8080

CMD ["catalina.sh", "run"]
