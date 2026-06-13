# syntax=docker/dockerfile:1.7

# ============================================================================
# RestCloud ETL 更新 - slim-buster-python3-fj
# ============================================================================

FROM nriet/restcloud:1.6.0-slim-buster-python3-fj

LABEL maintainer="Axiu <itzyx@vip.qq.com>"
LABEL org.opencontainers.image.title="RestCloud ETL Update"
LABEL org.opencontainers.image.version="1.6.1"

ENV RESTCLOUD_VERSION=1.6.1 \
    APP_USER=restcloud

# 下载并应用更新
RUN set -eux; \
    wget -O RestCloud-Update.zip "https://club.restcloud.cn/developers-server/rest/down/download_new?fileName=RestCloud-Update-V${RESTCLOUD_VERSION}.zip&type=3"; \
    unzip -d /tmp/RestCloud-Update RestCloud-Update.zip; \
    rm -rf RestCloud-Update.zip \
        /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/restcloud-* \
    ; \
    cp -rf /tmp/RestCloud-Update/initdata/* /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/initdata/; \
    cp -rf /tmp/RestCloud-Update/lib/* /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/; \
    rm -rf /tmp/RestCloud-Update \
        /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/restcloud-etlcore-1.4.0.jar \
    ; \
    # 清理
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

COPY restcloud-etlcore-1.4.0.jar /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/

# 确保非 root 用户能访问 Web 应用目录
RUN if getent passwd ${APP_USER} > /dev/null 2>&1; then \
        chown -R ${APP_USER}:${APP_USER} /usr/local/tomcat/webapps; \
    fi

USER ${APP_USER}

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD curl --fail --silent 'http://localhost:8080/restcloud/view/page/index.html' > /dev/null || exit 1

CMD ["catalina.sh", "run"]
