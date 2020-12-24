#!/bin/sh

read -r pid temp < "$(dirname $0)/.tsolock"
echo "PID is $pid"
echo "FIFO is $temp"
kill -USR1 $pid
cat > $temp
