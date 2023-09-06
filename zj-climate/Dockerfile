# FROM continuumio/miniconda3:latest

# RUN set -eux; \
# 	\
# 	conda create -n ncl_stable -c conda-forge ncl cdo imagemagick; \
# 	conda clean -y -a

# CMD ["conda", "run", "-n", "ncl_stable", "/bin/bash", "-c"]

FROM nriet/restcloud:2.5-slim-buster

MAINTAINER Axiu <itzyx@vip.qq.com>

ENV NCARG_ROOT :/app/ncl
ENV NCLJOB_ROOTS :/app/ncl_component
ENV PATH /app/ncl/bin:$PATH

COPY app/* /app/

COPY application.properties /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

COPY lib/* /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/

COPY sources.list /etc/apt/sources.list

RUN set -eux; \
	\
	tar zxvf /app/ncl.tar.gz -C /app; \
	rm -rf /app/ncl.tar.gz

# RUN apt-get update \
#       && apt-get install -y --no-install-recommends \
#        gcc-6/stretch fontconfig libssl-dev libidn11-dev libfontconfig1; \
#     rm -rf /var/lib/apt/lists/*


EXPOSE 8080
CMD ["catalina.sh", "run"]
