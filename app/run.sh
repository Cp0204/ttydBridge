#!/bin/bash

exec_dir=${EXEC_DIR:-"/opt"}
exec_path="$exec_dir/ttyd"
start_command=${START_COMMAND:-"login"}
host_exists_ttyd=0

# ttyd 选项
# https://github.com/tsl0922/ttyd#command-line-options
ttyd_options=()

# 监听端口
port=${PORT:-2222}
ttyd_options+=(-p "$port")

# 允许客户端写入TTY
allow_write=${ALLOW_WRITE:-"true"}
if [[ "$allow_write" != "false" ]]; then
    ttyd_options+=("-W")
fi

# 基本身份验证的凭据
http_username="${HTTP_USERNAME}"
http_password="${HTTP_PASSWORD}"
if [[ -n "$http_username" && -n "$http_password" ]]; then
    ttyd_options+=(-c "$http_username:$http_password")
fi

# 启用SSL
enable_ssl=${ENABLE_SSL:-"false"}
ssl_cert="${SSL_CERT}"
ssl_key="${SSL_KEY}"
ssl_ca="${SSL_CA}"
if [[ "$enable_ssl" != "false" ]]; then
    ttyd_options+=(-S)
    if [[ -n "$ssl_cert" ]]; then
        ttyd_options+=(-C "$ssl_cert")
    fi
    if [[ -n "$ssl_key" ]]; then
        ttyd_options+=(-K "$ssl_key")
    fi
    if [[ -n "$ssl_ca" ]]; then
        ttyd_options+=(-A "$ssl_ca")
    fi
fi

# 启用IPv6支持
enable_ipv6=${ENABLE_IPV6:-"false"}
if [[ "$enable_ipv6" != "false" ]]; then
    ttyd_options+=("-6")
fi

# 其他自定义选项
custom_options="${CUSTOM_OPTIONS}"
if [[ -n "$custom_options" ]]; then
    ttyd_options+=("$custom_options")
fi

start() {
    echo "Starting..."

    distro=$(grep '^PRETTY_NAME' /etc/os-release | awk -F '=' '{print $2}' | tr -d '"')
    arch=$(uname -m)
    echo "OS: ${distro} ${arch}"

    if [[ ! -d "$exec_dir" ]]; then
        echo "Creating directory ${exec_dir}"
        mkdir -p "$exec_dir"
    fi
    if [[ ! -f "$exec_path" ]]; then
        cp /usr/bin/ttyd $exec_path
        chmod +x $exec_path
        echo "Copy ttyd to $exec_path"
    else
        host_exists_ttyd=1
        echo "Host already exists $exec_path"
    fi

    exec_command="$exec_path ${ttyd_options[*]} $start_command"
    echo "ttyd startup options: $exec_command"
    nsenter -m -u -i -n -p -t 1 sh -c "$exec_command" &

    echo "Keep Running..."
    while true; do
        sleep 1
    done
}

stop() {
    echo "Stopping..."
    if [[ -f "$exec_path" && $host_exists_ttyd -eq 0 ]]; then
        rm "$exec_path"
        echo "Cleanup $exec_path"
    fi
    exit 0
}

trap 'stop' SIGINT SIGTERM SIGQUIT SIGHUP

case "$1" in
start)
    start
    ;;
stop)
    stop
    ;;
*)
    echo "Invalid command. Supported commands: start, stop"
    exit 1
    ;;
esac
