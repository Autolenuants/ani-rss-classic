FROM ibm-semeru-runtimes:open-21-jre-noble

ENV TZ=Asia/Shanghai
ENV DEBIAN_FRONTEND=noninteractive

# 仅安装时区与根证书基础库
RUN apt-get update && \
    apt-get install -y --no-install-recommends tzdata ca-certificates && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /app/config /app/data

WORKDIR /app

# 从 Actions 构建上下文中直接拷贝下载好的 jar 包
COPY app.jar /app/app.jar

EXPOSE 8088

# 增加全局网络超时系统参数以缓解 RSS 抓取 SocketTimeoutException 的问题
ENTRYPOINT ["java", "-Xquickstart", "-Duser.timezone=Asia/Shanghai", "-Dfile.encoding=UTF-8", "-Dsun.net.client.defaultConnectTimeout=60000", "-Dsun.net.client.defaultReadTimeout=60000", "-jar", "/app/app.jar"]
