FROM nriet/restcloud:1.6.0-slim-buster-python3

MAINTAINER Axiu <itzyx@vip.qq.com>

ENV NWP_PL_VERSION 1.0
COPY application.properties /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/
COPY app.tar.gz /

ENV GRIB_DEFINITION_PATH /app/NWP_PL_V${NWP_PL_VERSION}/definitions

ENV LD_LIBRARY_PATH :/app/NWP_PL_V${NWP_PL_VERSION}/lib


RUN set -eux; \
	\
	tar zxvf /app.tar.gz -C /; \
	rm -rf /app.tar.gz


COPY requirements.txt ./

#下载Era5认证文件
#https://cds.climate.copernicus.eu/cdsapp#!/dataset/reanalysis-era5-single-levels?tab=form
COPY .cdsapirc /root/

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8080

CMD ["catalina.sh", "run"]
