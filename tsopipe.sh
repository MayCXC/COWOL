#!/bin/sh

read -r pid cmd < .tsolock
echo $pid
echo $cmd