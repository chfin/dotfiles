#!/bin/sh

notify-send -i deja-dup "$1" "Backup Started"
yad --notification --text "Backup ($1) is running" --image deja-dup --command ""
