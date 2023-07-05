# docker-qqnt

在 Docker 中运行 QQNT 官方客户端

[GitHub](https://github.com/ilharp/docker-qqnt)
|
[GitHub Container Registry](https://github.com/ilharp/docker-qqnt/pkgs/container/docker-qqnt)
|
[Docker Hub](https://hub.docker.com/r/ilharp/qqnt)

## 使用

### 在线尝试

<a href="https://labs.play-with-docker.com/?stack=https://raw.githubusercontent.com/ilharp/docker-qqnt/master/docker-compose.yml" target="_blank"><img src="https://raw.githubusercontent.com/play-with-docker/stacks/master/assets/images/button.png" alt="Try in PWD" height="37"/></a>

### 使用 Docker

```sh
docker run --rm -it -p 6080:80 -p 5901 -e VNC_PASSWD=password ilharp/qqnt
```

### 使用 Docker Compose

```sh
docker compose up
```

### 使用 Docker Swarm

```sh
docker stack deploy --compose-file docker-compose.yml qqnt
```

### 使用浏览器连接

在浏览器中打开 [`http://localhost:6080`](http://localhost:6080) 然后输入密码 `password` 登录。

### 使用 VNC Viewer 连接

```sh
vncviewer :1 # 会连接到 127.0.0.1:5901
```

## 进入容器

进入容器（启动服务）：

```sh
docker run --rm -it -p 6080:80 -p 5901 -e VNC_PASSWD=password ilharp/qqnt /sbin/my_init -- bash -l
```

进入容器（不启动任何服务）：

```sh
docker run --rm -it -p 6080:80 -p 5901 -e VNC_PASSWD=password ilharp/qqnt bash
```

## 配方

### 持久化

- 持久化数据： `/root/.config/QQ`
- 持久化登录信息： `/root/.config/QQ/global/nt_db`

## 开发

### 构建 Linux QQ 镜像（自动）

先创建一个 builder：

```sh
docker buildx create --name container --driver=docker-container
```

构建镜像：

```sh
BUILD_DOCKER_BUILDER=container ./build.sh
```

### 构建 Windows QQ 镜像（手动）

构建 Windows QQ 镜像只能手动操作。手动构建的步骤较长，需要按步骤操作。

1. 启动 ifrstr/wine

```sh
docker run --name wine-pre -it -p 6080:80 -p 5901 -e VNC_PASSWD=password ifrstr/wine
```

2. 在浏览器中打开 [`http://localhost:6080`](http://localhost:6080) 然后输入密码 `password` 登录到 VNC

3. 另起一个终端，附加到容器

```sh
docker exec -it wine-pre bash
```

4. 运行下面的命令

```sh
# 配置 Wine 使用的显示屏
export DISPLAY=:1
# 安装中文字体
/usr/bin/winetricks cjkfonts
# 下载并安装 MSVC
curl -fsSLo /tmp/vcredist.exe https://aka.ms/vs/17/release/vc_redist.x64.exe
/usr/bin/wine /tmp/vcredist.exe
# 下载并安装 QQ
curl -fsSLo /tmp/qqinst.exe https://dldir1.qq.com/qqfile/qq/QQNT/bbabcfd7/QQ9.9.0.14569_x64.exe
/usr/bin/wine /tmp/qqinst.exe
# QQ 显示「完成安装」按钮时，直接按「Ctrl-C」结束安装进程
# 清理临时文件
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
```

运行完成后，返回第一个终端，按「Ctrl-C」结束容器

5. 提交容器为镜像

```sh
docker commit wine-pre wine-pre
```

6. 打开 `windows.dockerfile`，替换 `your-committed-image` 为刚刚提交的镜像名称

7. 执行后构建

```sh
docker build -t qqnt-windows windows.dockerfile
```

## 安全

### VNC

VNC 协议本身并不安全，所以不要将容器端口暴露在公网。

### Windows

Windows 镜像只能手动构建，Docker Registry 和 GitHub Container Registry 中的 Windows
镜像均为作者手动构建。如果需要安全构建，你需要按上面的步骤构建自己的镜像。

## :warning: 免责声明 :warning:

本项目仅供学习研究使用。

## 许可

[MIT](https://github.com/ilharp/docker-qqnt/blob/master/LICENSE)
