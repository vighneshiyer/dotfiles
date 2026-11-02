#!/bin/bash
# Installed to /usr/local/sbin/netwatch by run_onchange_after_devbox-system.sh; launchd runs it as root every 2 minutes.
set -u

STATE="${NETWATCH_STATE:-/var/db/netwatch}"
LOG="${NETWATCH_LOG:-/var/log/netwatch.log}"
PROBES="${NETWATCH_PROBES:-1.1.1.1 8.8.8.8 9.9.9.9}"
DRY_RUN="${NETWATCH_DRY_RUN:-0}"
REBOOT_AFTER=$((30 * 60))
MIN_UPTIME=$((60 * 60))
MIN_REBOOT_GAP=$((12 * 3600))
MAX_BACKOFF=$((30 * 60))

mkdir -p "$STATE/outage"
log() { echo "$(date '+%Y-%m-%d %H:%M:%S') $*" >>"$LOG"; }
act() { if [ "$DRY_RUN" = 1 ]; then log "dry-run: $*"; else "$@"; fi; }
reachable() { ping -q -c 2 -t 4 "$1" >/dev/null 2>&1; }
online() {
  local h
  for h in $PROBES; do reachable "$h" && return 0; done
  return 1
}
read_or() { cat "$1" 2>/dev/null || echo "$2"; }

now=$(date +%s)

if online; then
  if [ -f "$STATE/outage/since" ]; then
    log "online again after $((now - $(cat "$STATE/outage/since")))s ($(read_or "$STATE/outage/fixes" 0) fix attempts)"
    rm -rf "$STATE/outage"
  fi
  exit 0
fi

[ -f "$STATE/outage/since" ] || { echo "$now" >"$STATE/outage/since"; log "offline: no reply from $PROBES"; }
down_for=$((now - $(cat "$STATE/outage/since")))
fixes=$(read_or "$STATE/outage/fixes" 0)
last_fix=$(read_or "$STATE/outage/last_fix" 0)

route_out=$(route -n get default 2>/dev/null)
iface=$(awk '/interface:/{print $2}' <<<"$route_out")
gw=$(awk '/gateway:/{print $2}' <<<"$route_out")
wifi=$(networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/{getline; print $2}')

# The router answering means the LAN side is fine and the outage is upstream; bouncing our link won't help.
if [ -n "$gw" ] && reachable "$gw"; then
  [ -f "$STATE/outage/upstream_logged" ] || {
    log "gateway $gw on $iface answers, so the outage is upstream; leaving the network alone"
    touch "$STATE/outage/upstream_logged"
  }
  exit 0
fi

backoff=$((120 * (1 << (fixes < 4 ? fixes : 4))))
[ "$backoff" -gt "$MAX_BACKOFF" ] && backoff=$MAX_BACKOFF
if [ $((now - last_fix)) -ge "$backoff" ]; then
  if [ -n "$wifi" ] && { [ -z "$iface" ] || [ "$iface" = "$wifi" ]; }; then
    log "down ${down_for}s, gateway ${gw:-none} unreachable: power-cycling Wi-Fi ($wifi), attempt $((fixes + 1))"
    act networksetup -setairportpower "$wifi" off
    sleep 5
    act networksetup -setairportpower "$wifi" on
  elif [ -n "$iface" ]; then
    log "down ${down_for}s, gateway ${gw:-none} unreachable on $iface: renewing DHCP, attempt $((fixes + 1))"
    act ipconfig set "$iface" DHCP
  fi
  echo $((fixes + 1)) >"$STATE/outage/fixes"
  echo "$now" >"$STATE/outage/last_fix"
fi

boot=$(sysctl -n kern.boottime | sed -E 's/.*sec = ([0-9]+).*/\1/')
last_reboot=$(read_or "$STATE/last_reboot" 0)
if [ "$down_for" -ge "$REBOOT_AFTER" ] && [ "$fixes" -ge 3 ] \
  && [ $((now - boot)) -ge "$MIN_UPTIME" ] && [ $((now - last_reboot)) -ge "$MIN_REBOOT_GAP" ]; then
  # With FileVault on, a reboot parks the Mac at the unlock screen, which is worse than staying up and offline.
  if fdesetup status | grep -q "FileVault is On"; then
    [ -f "$STATE/outage/reboot_skipped" ] || {
      log "down ${down_for}s after $fixes fix attempts; not rebooting because FileVault would block the boot"
      touch "$STATE/outage/reboot_skipped"
    }
  else
    log "down ${down_for}s after $fixes fix attempts; rebooting"
    echo "$now" >"$STATE/last_reboot"
    act shutdown -r now "netwatch: network down for ${down_for}s"
  fi
fi
