#!/bin/sh

tail -F "$(dirname $0)/.tsolock" 2>/dev/null | grep -q '^[0-9]* .*$'
$(dirname $0)/tsoterm.sh << EOF
free f(sysin,sysprint,sysout)
alloc f(sysin) da(*)
alloc f(sysout) da(*)
call ($1)
EOF
