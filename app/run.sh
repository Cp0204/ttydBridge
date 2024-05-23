#!/bin/bash

exec_dir=${EXEC_DIR:-"/opt"}
exec_path="$exec_dir/ttyd"
start_command=${START_COMMAND:-"login"}
host_exists_ttyd=0
host_exists_iptables_rule=0

# ttyd 选项
# https://github.com/tsl0922/ttyd#command-line-options
ttyd_options=()

# 监听端口
port=${PORT:-2222}
ttyd_options+=(-p "$port")

# 自动放行端口
auto_allow_port=${AUTO_ALLOW_PORT:-"false"}

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

host_exec() {
    nsenter -m -u -i -n -p -t 1 sh -c "$1"
}

start() {
    echo "Starting..."

    distro=$(host_exec "grep '^PRETTY_NAME' /etc/os-release | awk -F '=' '{print \$2}' | tr -d '\"'")
    arch=$(host_exec "uname -m")
    echo "HostOS: $distro $arch"

    # Creating directory
    if [[ ! -d "$exec_dir" ]]; then
        echo "ExecDir: $exec_dir does not exist, creating"
        mkdir -p "$exec_dir"
    fi
    # Create executable
    if [[ ! -f "$exec_path" ]]; then
        echo "ttyd: Copy to $exec_path"
        cp /usr/bin/ttyd $exec_path
    else
        echo "ttyd: Host already exist $exec_path"
        host_exists_ttyd=1
    fi
    chmod +x $exec_path

    # auto allow port
    if [[ "$auto_allow_port" != "false" ]]; then
        port_check_error=$(
            host_exec "iptables -C INPUT -p tcp --dport $port -j ACCEPT" &>/dev/null
            echo $?
        )
        if [[ "$port_check_error" -eq 0 ]]; then
            echo "AutoAllowPort: Iptables rule $port exist"
            host_exists_iptables_rule=1
        else
            echo "AutoAllowPort: Iptables rule $port does not exist, auto allowing"
            host_exec "iptables -I INPUT -p tcp --dport $port -j ACCEPT"
        fi
    fi

    # exec
    exec_command="$exec_path ${ttyd_options[*]} $start_command"
    echo "ttyd startup command: $exec_command"
    host_exec "$exec_command" &

    echo "Keep Running..."
    while true; do
        sleep 1
    done
}

stop() {
    echo "Stopping..."
    if [[ -f "$exec_path" && $host_exists_ttyd -eq 0 ]]; then
        echo "ttyd: Cleanup $exec_path"
        rm "$exec_path"

    fi
    if [[ "$auto_allow_port" != "false" && $host_exists_iptables_rule -eq 0 ]]; then
        echo "AutoAllowPort: Delete iptables rule $port"
        host_exec "iptables -D INPUT -p tcp --dport $port -j ACCEPT"
    fi
    echo "Goodbye"
    echo ""
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
