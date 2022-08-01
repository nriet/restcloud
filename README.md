Restcloud ETL 社区版
https://club.restcloud.cn/article

镜像地址
https://hub.docker.com/r/nriet/restcloud

#### 临时测试
    建议使用docker-compose部署


# 镜像说明 
### nriet/restcloud:latest
* version：1.6.0
* os：slim-buster
* tomcat：基于官方镜像 tomcat:8.5.78-jdk8-openjdk-slim-buster
* jdk：openjdk-1.8.0_332
* python： 无
* other：中文语言包、中国标准时间、net-tools

### nriet/restcloud:1.6.0-slim-buster
* version：1.6.0
* os：slim-buster
* tomcat：基于官方镜像 tomcat:8.5.78-jdk8-openjdk-slim-buster
* jdk：openjdk-1.8.0_332
* python： 无
* other：中文语言包、中国标准时间、net-tools

### nriet/restcloud:1.6.0-slim-buster-python3
* version：1.6.0
* os：slim-buster
* tomcat：基于官方镜像 tomcat:8.5.78-jdk8-openjdk-slim-buster
* jdk：openjdk-1.8.0_332
* python： 3.9.13
* other：中文语言包、中国标准时间、net-tools



# docker命令部署

## 1.部署Mongodb
```docker
docker run --restart=always --name='mongo' -d \
-p 27017:27017 \
-e MONGO_INITDB_ROOT_USERNAME=MongoDB账号\
-e MONGO_INITDB_ROOT_PASSWORD=MongoDB密码\
-v 持久化目录:/data/db \
mongo:4.2.20-rc0-bionic
```


## 2.部署restcloud
### 自带ROOT
需要映射application.properties配置文件
```docker
docker run --restart=always --name='restcloud' -d \
-p 8080:8080 \
-e MONGODB_HOST=MongoDB地址:27017 \
-e MONGODB_USER=MongoDB账号\
-e MONGODB_PASSWORD=MongoDB密码\
nriet/restcloud:latest
```

### 不带ROOT
需要映射ROOT

```docker
docker run --restart=always --name='restcloud' -d \
-p 8080:8080 \
-v 持久化目录/ROOT:/usr/local/tomcat/webapps/ROOT \
nriet/tomcat:8.5.78-jdk8-openjdk-slim-buster-python3
```



# docker-compose 部署

### docker-compose.yml

```docker
version: "3.9"

services:
  mongo:
    image: mongo:4.2.20-rc0-bionic
    container_name: mongo
    ports:
      - "27017:27017"
    volumes:
      - mongo_db:/data/db
    restart: always
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: admin

  restcloud:
    depends_on:
      - mongo
    image: nriet/restcloud:latest
    container_name: restcloud
    ports:
      - "8080:8080"
    restart: always
    links:
      - mongo
    environment:
      MONGODB_HOST: mongo:27017
      MONGODB_USER: admin
      MONGODB_PASSWORD: admin
volumes:
  mongo_db: {}

```
### 启动Docker Compose
```docker
# 后台启动
docker-compose up -d
```