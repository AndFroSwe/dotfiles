#!/usr/bin/env bash

CURRENT=$(tlpctl | grep "\*" | sed "s/\* //")

CHOICE=$(printf "Performance\nBalanced\nPower Saver" | wofi --dmenu --height=160 --prompt  "TLP Power mode (${CURRENT})")

case "$CHOICE" in
  "Performance") MODE="performance" ;;
  "Balanced") MODE="balanced" ;; 
  "Power Saver") MODE="power-saver" ;;
*) exit 0 ;;
esac

exec tlpctl "$MODE"
