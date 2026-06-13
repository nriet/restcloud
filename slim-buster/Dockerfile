# syntax=docker/dockerfile:1.7

# ============================================================================
# RestCloud ETL - slim-buster（旧版 3.2，用于 legacy 部署）
# ============================================================================

FROM nriet/tomcat:8.5.82-jdk8-openjdk-slim-buster

LABEL maintainer="Axiu <itzyx@vip.qq.com>"
LABEL org.opencontainers.image.title="RestCloud ETL (slim-buster 旧版)"
LABEL org.opencontainers.image.version="3.2"

ENV TZ=PRC \
    RESTCLOUD_VERSION=3.2 \
    CATALINA_HOME=/usr/local/tomcat \
    APP_USER=restcloud

# 安装依赖、部署 RestCloud、创建非 root 用户（合并单层避免 chmod copy-up）
RUN set -eux; \
    # Debian Buster 已 EOL（2024-06），切换到 archive 源
    sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list; \
    sed -i 's|security.debian.org/debian-security|archive.debian.org/debian-security|g' /etc/apt/sources.list; \
    sed -i '/buster-updates/d' /etc/apt/sources.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        net-tools \
        wget \
        unzip \
    ; \
    rm -rf /var/cache/apt; \
    # 下载并部署 RestCloud
    wget -O ROOT.war "https://etl.restcloud.cn/download/RestCloud-ETL-V${RESTCLOUD_VERSION}.war" --no-check-certificate; \
    rm -rf /usr/local/tomcat/webapps/*; \
    unzip -oq ROOT.war -d /usr/local/tomcat/webapps/ROOT; \
    rm -rf ROOT.war; \
    # 设置时区
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone; \
    # 创建非 root 用户并设置权限
    groupadd -r ${APP_USER} --gid=1001; \
    useradd -r -g ${APP_USER} --uid=1001 -d ${CATALINA_HOME} -s /sbin/nologin ${APP_USER}; \
    chown -R ${APP_USER}:${APP_USER} ${CATALINA_HOME}/webapps ${CATALINA_HOME}/temp ${CATALINA_HOME}/work ${CATALINA_HOME}/logs

USER ${APP_USER}

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD curl --fail --silent 'http://localhost:8080/restcloud/view/page/index.html' > /dev/null || exit 1

CMD ["catalina.sh", "run"]
