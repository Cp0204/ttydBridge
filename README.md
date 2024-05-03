<div align="center">

![logo](https://cdn.jsdelivr.net/gh/Cp0204/CasaOS-AppStore-Play@main/Apps/ttydbridge/icon.png)

# ttydBridge

基于 ttyd 的 Docker 容器

如一座“桥”，连通了宿主机环境，让你在浏览器中轻松访问和使用宿主机终端

[![docker tag][docker-tag-image]][docker-url] [![docker pulls][docker-pulls-image]][docker-url] [![docker image size][docker-image-size-image]][docker-url]

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

| 变量名 | 默认值 | 描述 |
| --- | -------- | ---- |
| `EXEC_PATH` | `/opt/ttyd` | 运行路径，目录必须配合卷映射，不懂勿改 |
| `START_COMMAND` | `login` | ttyd初始运行命令 |
| `PORT` | `2222` | 网页端口 |

## 赞助

如果你觉得这个项目对你有帮助，可以给我一点点支持，非常感谢～

![WeChatPay](https://cdn.jsdelivr.net/gh/Cp0204/CasaMOD@main/img/wechat_pay_qrcode.png)

## 感谢

- [ttyd](https://github.com/tsl0922/ttyd): Share your terminal over the web
