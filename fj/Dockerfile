# syntax=docker/dockerfile:1.7

# ============================================================================
# RestCloud ETL - fj（福建）定制镜像
# 基于 nriet/restcloud:2.4-slim-buster-python3
# ============================================================================

FROM nriet/restcloud:2.4-slim-buster-python3

LABEL maintainer="Axiu <itzyx@vip.qq.com>"
LABEL org.opencontainers.image.title="RestCloud ETL - FJ"
LABEL org.opencontainers.image.description="RestCloud ETL 福建定制版（含 NWP 气象处理）"

ENV NWP_PL_VERSION=1.0 \
    GRIB_DEFINITION_PATH=/app/NWP_PL_V${NWP_PL_VERSION}/definitions \
    LD_LIBRARY_PATH=:/app/NWP_PL_V${NWP_PL_VERSION}/lib \
    APP_USER=restcloud

# 复制业务配置和依赖
COPY application.properties /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/
COPY lib/* /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/

# 安装 GDAL / PostGIS 等地理空间库
RUN set -eux; \
    # Debian Buster 已 EOL（2024-06），切换到 archive 源
    sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list; \
    sed -i 's|security.debian.org/debian-security|archive.debian.org/debian-security|g' /etc/apt/sources.list; \
    sed -i '/buster-updates/d' /etc/apt/sources.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        gdal-bin libgdal-dev libnetcdf-dev postgresql-client postgis; \
    rm -rf /var/lib/apt/lists/*

# 解压应用数据
COPY app.tar.gz /
RUN set -eux; \
    tar zxvf /app.tar.gz -C /; \
    rm -rf /app.tar.gz

# 安装 Python 依赖
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# ==================================================================
# 安全说明：以下凭据文件已在 Dockerfile 中移除，
# 改为使用 BuildKit secrets 或 docker-compose 挂载注入：
#
#   1. .pgpass      → PostgreSQL 认证（挂载到 ~/.pgpass）
#   2. .cdsapirc    → CDS API 认证（挂载到 ~/.cdsapirc）
#
# 运行时注入方式（二选一）：
#
#   A) docker-compose volumes:
#      volumes:
#        - ./fj/.pgpass:/home/restcloud/.pgpass:ro
#        - ./fj/.cdsapirc:/home/restcloud/.cdsapirc:ro
#
#   B) Docker BuildKit secrets（构建时注入，不留在镜像中）:
#      RUN --mount=type=secret,id=pgpass \
#          cp /run/secrets/pgpass ~/.pgpass
# ==================================================================

# 确保非 root 用户能访问
RUN set -eux; \
    if getent passwd ${APP_USER} > /dev/null 2>&1; then \
        chown -R ${APP_USER}:${APP_USER} /usr/local/tomcat/webapps /app; \
    else \
        groupadd -r ${APP_USER} --gid=1001; \
        useradd -r -g ${APP_USER} --uid=1001 -d ${CATALINA_HOME:-/usr/local/tomcat} -s /sbin/nologin ${APP_USER}; \
        chown -R ${APP_USER}:${APP_USER} /usr/local/tomcat/webapps /app; \
    fi

USER ${APP_USER}

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD curl --fail --silent 'http://localhost:8080/restcloud/view/page/index.html' > /dev/null || exit 1

CMD ["catalina.sh", "run"]
