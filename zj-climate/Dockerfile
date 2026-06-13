# syntax=docker/dockerfile:1.7

# ============================================================================
# RestCloud ETL - zj-climate（浙江气候）定制镜像
# 基于 nriet/restcloud:3.2-slim-buster-python3
# ============================================================================

FROM nriet/restcloud:3.2-slim-buster-python3

LABEL maintainer="Axiu <itzyx@vip.qq.com>"
LABEL org.opencontainers.image.title="RestCloud ETL - ZJ Climate"
LABEL org.opencontainers.image.description="RestCloud ETL 浙江气候定制版"

ENV APP_USER=restcloud

# 复制自定义 lib
COPY lib/* /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/

# 解决 Java JDBC 连接 SQL Server 的 TLS 版本问题
COPY java.security /usr/local/openjdk-8/jre/lib/security/

# 安装 curl（用于健康检查）
RUN set -eux; \
    # Debian Buster 已 EOL（2024-06），切换到 archive 源
    sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list; \
    sed -i 's|security.debian.org/debian-security|archive.debian.org/debian-security|g' /etc/apt/sources.list; \
    sed -i '/buster-updates/d' /etc/apt/sources.list; \
    apt-get update; \
    apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

# 安装 Python 依赖
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# 确保非 root 用户能访问
RUN if getent passwd ${APP_USER} > /dev/null 2>&1; then \
        chown -R ${APP_USER}:${APP_USER} /usr/local/tomcat/webapps; \
    fi

USER ${APP_USER}

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD curl --fail --silent 'http://localhost:8080/restcloud/view/page/index.html' > /dev/null || exit 1

CMD ["catalina.sh", "run"]
