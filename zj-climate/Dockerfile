FROM nriet/restcloud:2.5-slim-buster

MAINTAINER Axiu <itzyx@vip.qq.com>

ENV NCARG_ROOT :/app/ncl

ENV NCLJOB_ROOTS :/app/ncl_component

ENV PATH /app/ncl/bin:$PATH

COPY app/* /app/

COPY application.properties /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

COPY lib/* /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/

RUN apt-get update \
      && apt-get install -y --no-install-recommends \
       libssl-dev libidn11-dev; \
       ln -s /usr/lib/x86_64-linux-gnu/libssl.so libssl.so.10; \
       ln -s /usr/lib/x86_64-linux-gnu/libcrypt-2.28.so libcrypto.so.10; \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
	\
	tar zxvf /app/ncl.tar.gz -C /app; \
	rm -rf /app/ncl.tar.gz

EXPOSE 8080

CMD ["catalina.sh", "run"]
