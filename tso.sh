#!/bin/sh

temp=$(mktemp -u)
mkfifo $temp
echo "$$ $temp" > .tsolock
echo "PID is $$"
echo "FIFO is $temp"
echo "Beginning new address space..."
SERVLETKEY=$(zowe tso start as --sko)
echo "Key is $SERVLETKEY"
stuff="time"

tso_command() {
	zowe tso send as $SERVLETKEY --data $stuff || SERVLETKEY=$(zowe tso start as --sko)
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

prompt

