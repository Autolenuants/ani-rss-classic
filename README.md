# ani-rss v3.2.32 (OpenJ9 / amd64)

基于 `ani-rss` 官方 Release **v3.2.32**（支持 OpenList 的最终版本）自行构建的 Docker 镜像。

底包采用 **Ubuntu Noble + IBM Semeru Runtimes (OpenJ9 JDK 21)**，针对 NAS 等低功耗设备深度优化，相比官方默认版本可节省约 50% 的运行内存（日常常驻约 150MB~200MB）。

---

## 快速开始

### 1. 目录结构推荐

建议在 NAS 的 Docker 目录下创建独立存储空间（以飞牛 NAS `/vol1/1000/docker/ani-rss` 为例）：

```text
/vol1/1000/docker/ani-rss/
├── docker-compose.yml
├── config/             # 配置文件挂载目录
└── data/               # 数据库与订阅缓存挂载目录

```

### 2. 编写 `docker-compose.yml`

在工作目录下创建 `docker-compose.yml`：

```yaml
version: '3.8'

services:
  ani-rss:
    image: ghcr.io/<你的github用户名小写>/<你的仓库名小写>:openj9
    container_name: ani-rss
    restart: unless-stopped
    network_mode: bridge
    ports:
      - "8088:8088"
    volumes:
      - ./data:/app/data
      - ./config:/app/config
    environment:
      - TZ=Asia/Shanghai

```

> **注意**：
> 1. 请将 `image` 路径中的用户名和仓库名替换为您实际的 GitHub 命名（**必须全部保持小写**）。
> 2. 若 GHCR 仓库设置为 **Private**，部署前需在 NAS 终端执行一次登录：
> ```bash
> echo "<你的GITHUB_PAT密钥>" | docker login ghcr.io -u <你的GITHUB用户名> --password-stdin
> 
> ```
> 
> 
> 若已在 GitHub Package 设置中将该镜像设为 **Public**，则无需登录即可直接拉取。
> 
> 

---

## 启动与维护

### 启动服务

在包含 `docker-compose.yml` 的目录下执行：

```bash
# 启动并后台运行
docker compose up -d

# 查看实时启动日志
docker compose logs -f

```

### 访问 Web 页面

容器启动约 15~30 秒完成初始化后，即可通过浏览器访问控制面板：

* 访问地址：`http://<NAS_IP>:8088`
* 默认端口：`8088`

---

## 配置参数说明

| 参数项 | 类型 | 默认值 / 示例 | 说明 |
| --- | --- | --- | --- |
| `image` | 镜像地址 | `...:openj9` | OpenJ9 架构低内存镜像 |
| `8088:8088` | 端口映射 | `宿主机端口:容器端口` | 若宿主机 8088 已被占用，只需修改冒号左侧（如 `8099:8088`） |
| `./data:/app/data` | 目录挂载 | 持久化数据 | 存储本地 SQLite 数据库、番剧更新记录 |
| `./config:/app/config` | 目录挂载 | 持久化配置 | 存储应用配置文件及密钥数据 |
| `TZ` | 环境变量 | `Asia/Shanghai` | 确保 RSS 抓取定时任务遵循中国标准时间 |

---

## 常用运维命令

```bash
# 检查容器状态及实际内存占用
docker stats ani-rss --no-stream

# 重启服务
docker compose restart

# 停止并移除容器（数据不受影响）
docker compose down

# 强制重新拉取云端新构建的镜像并重启
docker compose pull && docker compose up -d

```

```

```
