#!/usr/bin/env bash
# Vanilla drop-down scratchpad toggle for AeroSpace (no third-party tools).
#
#   scratchpad.sh <app-name> <title-substring> <launch command...>
#
# Pass "" for <title-substring> to match by app name only (e.g. Spotify).
#
# Behaviour:
#   - window not running        -> run the launch command
#   - window on this workspace  -> stash it to the hidden "scratch" workspace
#   - window on another workspace -> pull it here and focus it
set -euo pipefail

stash="scratch"                 # a workspace you never switch to manually
app="$1"; title="$2"; shift 2

# window-id + current workspace of the first window matching app (+ optional title)
line="$(aerospace list-windows --all \
          --format '%{window-id}|%{workspace}|%{app-name}|%{window-title}' \
        | awk -F'|' -v a="$app" -v t="$title" \
            'index($3,a) && (t=="" || index($4,t)) {print $1, $2; exit}')"

if [ -z "$line" ]; then
  exec "$@"                     # not running yet -> launch it
fi

read -r wid ws <<< "$line"
focused="$(aerospace list-workspaces --focused --format '%{workspace}')"

if [ "$ws" = "$focused" ]; then
  aerospace move-node-to-workspace --window-id "$wid" "$stash"      # hide
else
  aerospace move-node-to-workspace --window-id "$wid" "$focused"    # show here
  aerospace focus --window-id "$wid"
fi
