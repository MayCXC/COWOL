#!/bin/sh

. "$(dirname $0)/jclcobol.sh" << 'EOF'
//COWOLJCL    JOB 1,NOTIFY=&SYSUID
//COWOLIGY   EXEC IGYWCL
//COBOL.SYSIN  DD DSN=&SYSUID..SOURCE($DESTNAME),DISP=SHR
//LKED.SYSLMOD DD DSN=&SYSUID..LOAD($DESTNAME),DISP=SHR
EOF

tail -F "$(dirname $0)/.tsolock" 2>/dev/null | grep -q '^[0-9]* .*$'
$(dirname $0)/tsoterm.sh << EOF
free f(sysin,sysout)
alloc f(sysin) da(*)
alloc f(sysout) da(*)
call ($DESTNAME)
EOF
