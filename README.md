<div align="center">

![logo](img/icon.png)

# ttydBridge

English | [简体中文](/README_CN.md)

Docker containers based on ttyd bypass the isolation mechanism.

A "bridge" to the host environment, allowing you to easily use the host terminal in your browser.

[![docker tag][docker-tag-image]][github-url] [![docker pulls][docker-pulls-image]][docker-url] [![docker image size][docker-image-size-image]][docker-url]

[docker-tag-image]: https://img.shields.io/docker/v/cp0204/ttydbridge
[docker-pulls-image]: https://img.shields.io/docker/pulls/cp0204/ttydbridge
[docker-image-size-image]: https://img.shields.io/docker/image-size/cp0204/ttydbridge
[github-url]: https://github.com/Cp0204/ttydbridge
[docker-url]: https://hub.docker.com/r/cp0204/ttydbridge

</div>

## Usage

Run the container:

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

Access the web terminal via `http://yourhost:2222` and login with your system user.

## Environment

| Name                            | Default | Description                                                                                               |
| ------------------------------- | ------- | --------------------------------------------------------------------------------------------------------- |
| `EXEC_DIR`                      | `/opt`  | Program execution dir, must be consistent with volume mappings, **DO NOT MODIFY if you don't understand** |
| `START_COMMAND`                 | `login` | ttyd initial command, `login` uses system authentication, `bash` enters directly                          |
| `PORT`                          | `2222`  | Web port                                                                                                  |
| `ALLOW_WRITE`                   | `true`  | Allow terminal input                                                                                      |
| `HTTP_USERNAME` `HTTP_PASSWORD` |         | HTTP basic authentication, effective when set at the same time                                            |
| `ENABLE_SSL`                    | `false` | Enable SSL (https)                                                                                        |
| `SSL_CERT` `SSL_KEY` `SSL_CA`   |         | Host certificate paths, effective when ENABLE_SSL=true                                                    |
| `ENABLE_IPV6`                   | `false` | Enable IPv6 support                                                                                       |
| `AUTO_ALLOW_PORT`               | `false` | Automatically allow web ports                                                                             |

## Sponsor

If you find this project helpful, you can give me a little support, thank you very much~

![WeChatPay](img/wechat_pay_qrcode.png)

## Thank

- [ttyd](https://github.com/tsl0922/ttyd) : Share your terminal over the web
