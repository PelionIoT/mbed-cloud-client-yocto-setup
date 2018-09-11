#!/bin/sh

start() {
  echo "To stop, send exit command in mbedCloudClientExample."
  /opt/arm/mbedCloudClientExample.elf < /dev/ttyS0
}

stop() {
  echo "To stop, send exit command in mbedCloudClientExample."
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  *)
    echo "Usage: $0 {start}"
esac

