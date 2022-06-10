FROM nriet/restcloud:1.4.0-slim-buster-python3

MAINTAINER Axiu <itzyx@vip.qq.com>

ENV NWP_PL_VERSION 1.0

COPY NWP_PL_V${NWP_PL_VERSION}.tar.gz /app/

ENV GRIB_DEFINITION_PATH /app/NWP_PL_V${NWP_PL_VERSION}/definitions

ENV LD_LIBRARY_PATH :/app/NWP_PL_V${NWP_PL_VERSION}/lib


RUN set -eux; \
	\
	tar zxvf /app/NWP_PL_V${NWP_PL_VERSION}.tar.gz -C /app/; \
	rm -rf /app/NWP_PL_V${NWP_PL_VERSION}.tar.gz


COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8080

CMD ["catalina.sh", "run"]
