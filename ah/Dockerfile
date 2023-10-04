FROM nriet/restcloud:1.6.1-slim-buster-python3

MAINTAINER Axiu <itzyx@vip.qq.com>

COPY application.properties /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

COPY lib/* /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8080

CMD ["catalina.sh", "run"]
