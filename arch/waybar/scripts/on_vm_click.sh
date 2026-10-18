#!/bin/bash

vmname="win11"

if pgrep -f "hyprland-dialog --title Select a VM option" >/dev/null; then
  exit 0
fi

state() { virsh domstate "$vmname"; }

safe_start() {
  if [[ "$(state)" == "running" ]]; then
    return 0
  fi
  virsh start "$vmname"
}

safe_suspend() {
  if [[ "$(state)" == "paused" ]]; then
    return 0
  fi
  virsh suspend "$vmname"
}

safe_shutdown() {
  if [[ "$(state)" == "shut off" ]]; then
    return 0
  fi
  virsh shutdown "$vmname"
}

answer=$(hyprland-dialog --title "Select a VM option" \
  --apptitle "VM Control" \
  --text "Choose an action for VM $vmname" \
  --buttons "Start;Suspend;Shutdown;Cancel")

if [[ -z "$answer" || "$answer" == "Cancel" ]]; then
  exit 0
fi

case "$answer" in
  Start)    safe_start ;;
  Suspend)  safe_suspend ;;
  Shutdown) safe_shutdown ;;
  *) printf 'Unknown answer: %s\n' "$answer" >&2; exit 1 ;;
esac
