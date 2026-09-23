FROM ibm-semeru-runtimes:open-21-jre-noble

ENV TZ=Asia/Shanghai
ENV DEBIAN_FRONTEND=noninteractive

# 安装基础工具并锁定中国时区
RUN apt-get update && \
    apt-get install -y --no-install-recommends tzdata wget ca-certificates && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /app/config /app/data

WORKDIR /app

# 下载 v3.2.32 的 Release jar 包
RUN wget -O /app/app.jar https://github.com/wushuo894/ani-rss/releases/download/v3.2.32/ani-rss-3.2.32.jar

EXPOSE 8088

# -Xquickstart: 开启 OpenJ9 专有的冷启动与内存压缩优化
ENTRYPOINT ["java", "-Xquickstart", "-Duser.timezone=Asia/Shanghai", "-Dfile.encoding=UTF-8", "-jar", "/app/app.jar"]
