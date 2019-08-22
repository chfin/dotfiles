#!/bin/sh

sleep 0.5

logger -t DOCKING "running dock script ($ACTION)"

username=chfin

if [[ "$ACTION" == "add" ]]; then
  DOCKED=1
  logger -t DOCKING "Detected condition: docked"
elif [[ "$ACTION" == "remove" ]]; then
  DOCKED=0
  logger -t DOCKING "Detected condition: un-docked"
else
  logger -t DOCKING "Detected condition: unknown"
  echo Please set env var \$ACTION to 'add' or 'remove'
  exit 1
fi

export DISPLAY=:0

case "$DOCKED" in
  "0")
    su $username -c '/home/chfin/.screenlayout/laptop.sh' ;;
  "1")
    su $username -c '/home/chfin/.local/bin/add-screen' ;;
esac
