FROM ibm-semeru-runtimes:open-21-jre-noble

ENV TZ=Asia/Shanghai
ENV DEBIAN_FRONTEND=noninteractive

# 配置时区并拉取工具
RUN apt-get update && \
    apt-get install -y --no-install-recommends tzdata wget ca-certificates && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /app/config /app/data

WORKDIR /app

RUN wget -O /app/app.jar https://github.com/wushuo894/ani-rss/releases/download/v3.2.32/ani-rss-3.2.32.jar

EXPOSE 8088

# OpenJ9 专有参数：-Xquickstart 提升启动速度并削减常驻堆外内存
ENTRYPOINT ["java", "-Xquickstart", "-Duser.timezone=Asia/Shanghai", "-Dfile.encoding=UTF-8", "-jar", "/app/app.jar"]
