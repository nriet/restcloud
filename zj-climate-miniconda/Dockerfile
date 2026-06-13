# syntax=docker/dockerfile:1.7

# ============================================================================
# RestCloud ETL - zj-climate-miniconda 定制镜像
# 基于 nriet/restcloud:2.5-slim-buster
# ============================================================================

# ---- 阶段 1: 下载 Miniconda ----
FROM debian:buster-slim AS conda-downloader

# 仅下载，不解压（避免在最终镜像中残留下载器）
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends wget ca-certificates; \
    wget -O /miniconda.sh "https://repo.anaconda.com/miniconda/Miniconda3-py38_23.1.0-1-Linux-x86_64.sh"; \
    rm -rf /var/lib/apt/lists/*


# ---- 阶段 2: 运行时 ----
FROM nriet/restcloud:2.5-slim-buster

LABEL maintainer="Axiu <itzyx@vip.qq.com>"
LABEL org.opencontainers.image.title="RestCloud ETL - ZJ Climate Miniconda"
LABEL org.opencontainers.image.description="RestCloud ETL 浙江气候定制版（含 Miniconda）"

ENV PATH=/opt/miniconda/bin:${PATH} \
    NCLJOB_ROOTS=:/app/ncl_component \
    APP_USER=restcloud

# 复制业务配置和依赖
COPY application.properties /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/
COPY lib/* /usr/local/tomcat/webapps/ROOT/WEB-INF/lib/

# 安装 Miniconda（合并为单层减少镜像层数）
COPY --from=conda-downloader /miniconda.sh /tmp/miniconda.sh
RUN set -eux; \
    bash /tmp/miniconda.sh -p /opt/miniconda -b; \
    rm -f /tmp/miniconda.sh; \
    /opt/miniconda/bin/conda update -y conda; \
    /opt/miniconda/bin/conda clean -y -a; \
    # 清理 conda 缓存
    rm -rf /opt/miniconda/pkgs/*

# 确保非 root 用户能访问
RUN set -eux; \
    if getent passwd ${APP_USER} > /dev/null 2>&1; then \
        chown -R ${APP_USER}:${APP_USER} /usr/local/tomcat/webapps /opt/miniconda; \
    else \
        groupadd -r ${APP_USER} --gid=1001; \
        useradd -r -g ${APP_USER} --uid=1001 -d ${CATALINA_HOME:-/usr/local/tomcat} -s /sbin/nologin ${APP_USER}; \
        chown -R ${APP_USER}:${APP_USER} /usr/local/tomcat/webapps /opt/miniconda; \
    fi

USER ${APP_USER}

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 \
    CMD curl --fail --silent 'http://localhost:8080/restcloud/view/page/index.html' > /dev/null || exit 1

CMD ["catalina.sh", "run"]
