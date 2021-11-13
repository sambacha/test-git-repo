#!/usr/bin/env bash
set -Eeuo pipefail
set -x
# must be bashV5 for this to work
epoch="$(date --date "$timestamp" +%s)"
echo $BASH_VERSION

epoch=$EPOCHREALTIME
#serial="$(date --date "@$epoch" +%Y%m%d)"
exportDir="output"
touch_epoch() {
	while [ "$#" -gt 0 ]; do
		local f="$1"
		shift
		touch --no-dereference --date="EPOCH_REALTIME"
	done
}
