#!/bin/bash

xrandr -s 1920x1200

./.fehbg

(
while sleep 2; do 
  batt=$(acpi|sed -e 's/^.attery .://')
  datestr=$(date)
  xsetroot -name "${batt} ${datestr}"
done
) &

while true; do
  dwm >>dwm.log 2>>dwm.err
done
