# syntax=docker/dockerfile:1.7

# ============================================================================
# RestCloud ETL - 主镜像（无 Python）
# 基于 nriet/tomcat:8.5-jdk8
# ============================================================================

FROM nriet/tomcat:8.5-jdk8

LABEL maintainer="Axiu <itzyx@vip.qq.com>"
LABEL org.opencontainers.image.title="RestCloud ETL"
LABEL org.opencontainers.image.description="RestCloud ETL Community Edition - Data Integration Platform（无 Python）"
LABEL org.opencontainers.image.version="4.2"
LABEL org.opencontainers.image.source="https://github.com/nriet/restcloud"

ARG RESTCLOUD_VERSION=4.2

ENV TZ=PRC \
    CATALINA_HOME=/usr/local/tomcat \
    UNZIP_DISABLE_ZIPBOMB_DETECTION=TRUE \
    APP_USER=restcloud

# 设置时区
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 安装运行时依赖、部署 RestCloud、创建非 root 用户（合并在单层避免 chmod 触发 overlay copy-up）
# build-essential / libhdf5-dev 等为 ETL 引擎的 JNI 原生库所需
RUN set -eux; \
    RESTCLOUD_WAR_URL="https://github.com/nriet/restcloud/releases/download/${RESTCLOUD_VERSION}/RestCloud-ETL-V${RESTCLOUD_VERSION}.zip"; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        build-essential \
        libhdf5-dev \
        zlib1g-dev \
        libnetcdf-dev \
        libcurl4-openssl-dev \
        zip \
        unzip \
        curl \
    ; \
    # 清除默认 web 应用
    rm -rf ${CATALINA_HOME}/webapps/*; \
    rm -rf ${CATALINA_HOME}/webapps.dist; \
    # 下载并部署 RestCloud（ZIP 无 ROOT 目录，解压到 webapps/ROOT/）
    curl -fSL "${RESTCLOUD_WAR_URL}" -o ROOT.zip; \
    mkdir -p ${CATALINA_HOME}/webapps/ROOT; \
    unzip -q ROOT.zip -d ${CATALINA_HOME}/webapps/ROOT; \
    rm -f ROOT.zip; \
    # 清理 apt 缓存
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*; \
    # 创建非 root 用户并设置权限（与解压在同一层，避免 overlay filesystem 拷贝文件）
    groupadd -r ${APP_USER} --gid=1001; \
    useradd -r -g ${APP_USER} --uid=1001 -d ${CATALINA_HOME} -s /sbin/nologin ${APP_USER}; \
    chown -R ${APP_USER}:${APP_USER} ${CATALINA_HOME}/webapps ${CATALINA_HOME}/temp ${CATALINA_HOME}/work ${CATALINA_HOME}/logs

USER ${APP_USER}

EXPOSE 8080 8443

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD curl --fail --silent 'http://localhost:8080/restcloud/view/page/index.html' > /dev/null || exit 1

CMD ["catalina.sh", "run"]
