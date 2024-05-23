<div align="center">

![logo](img/icon.png)

# ttydBridge

[English](/README.md) | 简体中文

基于 ttyd 绕过了隔离机制的 Docker 容器

如一座“桥”，连通了宿主机环境，让你在浏览器中轻松使用宿主机终端

[![docker tag][docker-tag-image]][github-url] [![docker pulls][docker-pulls-image]][docker-url] [![docker image size][docker-image-size-image]][docker-url]

[docker-tag-image]: https://img.shields.io/docker/v/cp0204/ttydbridge
[docker-pulls-image]: https://img.shields.io/docker/pulls/cp0204/ttydbridge
[docker-image-size-image]: https://img.shields.io/docker/image-size/cp0204/ttydbridge
[github-url]: https://github.com/Cp0204/ttydbridge
[docker-url]: https://hub.docker.com/r/cp0204/ttydbridge

</div>

## 使用

运行容器：

```shell
docker run -d \
  --name ttdybridge \
  -e PORT=2222 \
  -v /opt:/opt \
  --pid host \
  --privileged \
  --restart unless-stopped \
  cp0204/ttdybridge:latest
```

通过 `http://yourhost:2222` 访问网页终端，使用系统用户登录。

## 环境变量

| 变量名                          | 默认值  | 描述                                               |
| ------------------------------- | ------- | -------------------------------------------------- |
| `EXEC_DIR`                      | `/opt`  | 程序运行目录，必须配合卷映射三处一致，**不懂勿改** |
| `START_COMMAND`                 | `login` | ttyd 初始命令，`login`使用系统鉴权，`bash`直接进入 |
| `PORT`                          | `2222`  | 网页端口                                           |
| `ALLOW_WRITE`                   | `true`  | 允许终端输入                                       |
| `HTTP_USERNAME` `HTTP_PASSWORD` |         | HTTP基础认证，同时设置时生效                       |
| `ENABLE_SSL`                    | `false` | 启用 SSL （https）                                 |
| `SSL_CERT` `SSL_KEY` `SSL_CA`   |         | 主机证书路径，当 ENABLE_SSL=true 时生效            |
| `ENABLE_IPV6`                   | `false` | 启用 IPv6 支持                                     |
| `AUTO_ALLOW_PORT`               | `false` | 自动放行网页端口                                   |

## 赞助

如果你觉得这个项目对你有帮助，可以给我一点点支持，非常感谢～

![WeChatPay](img/wechat_pay_qrcode.png)

## 感谢

- [ttyd](https://github.com/tsl0922/ttyd) : Share your terminal over the web
