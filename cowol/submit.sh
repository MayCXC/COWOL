#!/bin/sh

WSLNAME=$1
if command -v wslpath >/dev/null 2>&1
then
    WSLNAME=$(wslpath $WSLNAME)
fi
export SRCNAME=$(realpath $WSLNAME)
export DESTNAME=$(basename $WSLNAME | cut -d. -f1 | cut -c -8 | tr [:lower:] [:upper:])
export ANSIBLE_CONFIG="$(dirname $0)/../ansible.cfg"

. ~/.profile
export PATH

ansible-playbook "$(dirname $0)/../submit_source.yml" \
    --extra-vars "cowol_src=$SRCNAME cowol_dest=$DESTNAME"
