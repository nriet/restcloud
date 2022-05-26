FROM nriet/restcloud:1.2.1

MAINTAINER Axiu <itzyx@vip.qq.com>

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8080

CMD ["catalina.sh", "run"]
