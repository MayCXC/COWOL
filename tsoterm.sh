#!/bin/sh

temp=$(mktemp -u)
mkfifo $temp
echo "$$ $temp" > .tsolock
echo "PID is $$"
echo "FIFO is $temp"
stuff="time"

tso_as() {
	echo "Beginning new address space..."
	SERVLETKEY=$(zowe tso start as --sko)
	echo "Key is $SERVLETKEY"
}

tso_command() {
	zowe tso send as $SERVLETKEY --data $stuff || tso_as
}

prompt() {
	while read -r line
	do
		tso_command
	done
}

signal() {
	read -r line <$temp
	tso_command
	prompt
}

trap signal USR1

cleanup() {
	rm .tsolock
	rm $temp
	zowe tso stop as $SERVLETKEY
}

trap cleanup INT

tso_as

prompt
