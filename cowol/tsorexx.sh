#!/bin/sh

. "$(dirname $0)/submit.sh"

tail -F "$(dirname $0)/.tsolock" 2>/dev/null | grep -q '^[0-9]* .*$'
$(dirname $0)/tsoterm.sh << EOF
free f(SYSEXEC)
alloc f(SYSEXEC) da(SOURCE)
%$DESTNAME
EOF