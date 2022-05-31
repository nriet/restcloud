Restcloud ETL 社区版
https://club.restcloud.cn/article


## 1.安装mongodb
```docker
docker run --restart=always --name='mongo' -d \
-p 27017:27017 \
-e MONGO_INITDB_ROOT_USERNAME=admin -e MONGO_INITDB_ROOT_PASSWORD=admin \
-v 持久化目录:/data/db \
mongo:4.2.20-rc0-bionic
```


## 2.1部署restcloud（自带ROOT）
需要映射application.properties配置文件
```docker
docker run --restart=always --name='restcloud' -d \
-p 8080:8080 \
-v 持久化目录/application.properties:/usr/local/tomcat/webapps/ROOT/WEB-INF/classes/application.properties \
nriet/restcloud:1.3.0
```


## 2.2部署restcloud（不带ROOT）
需要映射ROOT
```
docker run --restart=always --name='restcloud' -d \
-p 8080:8080 \
-v 持久化目录/ROOT:/usr/local/tomcat/webapps/ROOT \
nriet/tomcat:8.5.78-jdk8-openjdk-slim-buster-python3
```


## 镜像说明
* os：slim-buster
* tomcat：基于官方tomcat 8.5.78镜像 https://hub.docker.com/_/tomcat?tab=description
* jdk：openjdk1.8.0_332
* other：Python 3.9.13、中文语言包、net-tools
