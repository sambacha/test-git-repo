#!/bin/bash
# Grzegorz Wierzowiecki
# "mutex_dir.sh"
# GNU GPL or BSD - as you like
# Script inspiered by:
# http://www.bash-hackers.org/wiki/doku.php/howto/mutex

function print_help() {
	cat <<HELP_INFO
Usage:
$0 lock lock-dir calling_app_pid
$0 unlock lock-dir
Return:
0 - on success
1 - on general fail
2 - when locking failed
3 - when received signal
HELP_INFO
	exit
}

# lock dirs/files
lock_dir="$2"
app_pid="$3"
pid_file="${lock_dir}/pid"

# exit codes and text for them - additional features nobody needs :-)
ENO_SUCCESS=0
ETXT[0]="ENO_SUCCESS"
ENO_GENERAL=1
ETXT[1]="ENO_GENERAL"
ENO_LOCKFAIL=2
ETXT[2]="ENO_LOCKFAIL"
ENO_RECVSIG=3
ETXT[3]="ENO_RECVSIG"

# start un/locking attempt
#trap 'ECODE=$?; echo "[statsgen] Exit: ${ETXT[ECODE]}($ECODE)" >&2' 0

function lock() {
	if ! kill -0 "$app_pid" &>/dev/null; then
		echo 'Calling app pid (='"$app_pid"')is not reposnding.'
		return 1
	fi
	local lock_dir="$1"
	if mkdir "${lock_dir}" &>/dev/null; then
		# lock succeeded, store the PID
		echo "$app_pid" >"${pid_file}"
		return ${ENO_SUCCESS}
	else
		# lock failed, now check if the other PID is alive
		other_pid="$(cat "${pid_file}" 2>/dev/null)"
		if [ $? != 0 ]; then
			# Pid file does not exists - propably direcotry is beeing deleted
			return ${ENO_LOCKFAIL}
		fi
		if ! kill -0 "$other_pid" &>/dev/null; then
			# lock is stale, remove it and restart
			unlock "$lock_dir"
			lock "$lock_dir"
			return $?
		else
			# lock is valid and OTHERPID is active - exit, we're locked!
			#echo "lock failed, PID ${OTHERPID} is active" >&2
			return ${ENO_LOCKFAIL}
		fi
	fi
	return 0
}

function unlock() {
	rm -r "$1" &>/dev/null
	return $?
}

case "$1" in
lock)
	lock "$lock_dir"
	exit $?
	;;
unlock)
	unlock "$lock_dir"
	exit $?
	;;
*) print_help ;;
esac
