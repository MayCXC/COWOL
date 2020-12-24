#!/bin/sh

stuff="time"

tso_as() {
	echo "Beginning new address space..."
	SERVLETKEY=$(zowe tso start as --sko)
	echo "Key is $SERVLETKEY"
	tso_command
}

tso_command() {
	zowe tso send as $SERVLETKEY --data "$stuff" || tso_as
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

temp=$(mktemp -u)
mkfifo $temp
echo "$$ $temp" > "$(dirname $0)/.tsolock"
echo "PID is $$"
echo "FIFO is $temp"

prompt
