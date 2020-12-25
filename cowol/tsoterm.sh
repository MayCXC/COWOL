#!/bin/sh

if read -r pid fifo >/dev/null 2>&1 < "$(dirname $0)/.tsolock"
then
	echo "PID is $pid"
	echo "FIFO is $fifo"
	kill -USR1 $pid
	cat > $fifo
	exit
fi

temp=$(mktemp -u)
mkfifo $temp
echo "$$ $temp" > "$(dirname $0)/.tsolock"
echo "PID is $$"
echo "FIFO is $temp"

stuff="time"

tso_as() {
	echo "Beginning new address space..."
	SERVLETKEY=$(zowe tso start as --sko)
	echo "Key is $SERVLETKEY"
}

tso_command() {
	if ! zowe tso send as $SERVLETKEY --data "$stuff"
	then
		tso_as
		zowe tso send as $SERVLETKEY --data "$stuff"
		stuff=""
	fi
}

prompt() {
	while read -r stuff
	do
		tso_command
	done
}

signal() {
	while read -r stuff
	do
		echo "$stuff"
		tso_command
	done < $temp
	prompt
}

trap signal USR1

cleanup() {
	trap 'cleanup' INT TERM
	rm -f "$(dirname $0)/.tsolock"
	rm -f $temp
	zowe tso stop as $SERVLETKEY
	exit
}

trap 'cleanup' INT TERM

tso_as

prompt
