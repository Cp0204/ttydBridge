#!/bin/bash

exec_path=${EXEC_PATH:-"/opt/ttyd"}
port=${PORT:-2222}
start_command=${START_COMMAND:-login}
host_exists_ttyd=0

start() {
    echo "Starting..."

    if [[ ! -f "$exec_path" ]]; then
        cp /usr/bin/ttyd $exec_path
        echo "Copy ttyd to $exec_path"
    else
        host_exists_ttyd=1
        echo "Host exists $exec_path"
    fi

    nsenter -m -u -i -n -p -t 1 sh -c "$exec_path -p $port -W $start_command" &

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
