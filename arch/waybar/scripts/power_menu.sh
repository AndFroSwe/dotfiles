#!/bin/bash

if pgrep -f "hyprland-dialog --title Select an action" >/dev/null; then
  exit 0
fi

confirm() {
  local reply
  reply=$(hyprland-dialog --title "Confirm $1" \
    --apptitle "Power Control" \
    --text "Are you sure you want to $2?" \
    --buttons "Yes;No")
  [[ "$reply" == "Yes" ]]
}

safe_lock()               { exec hyprlock; }
safe_suspend()            { systemctl suspend; }
safe_shutdown()           { confirm "Shutdown ⚡" "shut down" && systemctl poweroff; }
safe_reboot()             { confirm "Reboot ☕" "reboot" && systemctl reboot; }
safe_hibernate()          { confirm "Hibernate 🐻" "hibernate" && systemctl hibernate; }
safe_suspend_hibernate()  { confirm "Suspend-Hibernate 💤" "suspend then hibernate" && systemctl suspend-then-hibernate; }

answer=$(hyprland-dialog --title "Select an action" \
  --apptitle "Power Control" \
  --text "⚡ Select a power action ⚡" \
  --buttons "Shutdown;Reboot;Hibernate;Suspend-Hibernate;Suspend;Lock;Cancel")

case "$answer" in
  ""|Cancel)         exit 0 ;;
  Lock)              safe_lock ;;
  Suspend)           safe_suspend ;;
  Shutdown)          safe_shutdown ;;
  Reboot)            safe_reboot ;;
  Hibernate)         safe_hibernate ;;
  Suspend-Hibernate) safe_suspend_hibernate ;;
  *) printf 'Unknown answer: %s\n' "$answer" >&2; exit 1 ;;
esac
