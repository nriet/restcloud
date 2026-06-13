# syntax=docker/dockerfile:1.7

# ============================================================================
# RestCloud ETL - ah（安徽）定制镜像
# 基于 nriet/restcloud:1.6.1-slim-buster-python3
# ============================================================================

FROM nriet/restcloud:1.6.1-slim-buster-python3

LABEL maintainer="Axiu <itzyx@vip.qq.com>"
LABEL org.opencontainers.image.title="RestCloud ETL - AH"
LABEL org.opencontainers.image.description="RestCloud ETL 安徽定制版"

ENV APP_USER=restcloud

# 复制业务配置和依赖
COPY application.properties /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/
COPY lib/* /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/

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
