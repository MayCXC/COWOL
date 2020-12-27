#!/bin/sh

. "$(dirname $0)/submit.sh"

JCLNAME=$(mktemp)
if [ ! -t 0 ]
then
envsubst >> $JCLNAME
elif [ ! -z "$2" ]
then
cat "$(dirname $SRCNAME)/$2" >> $JCLNAME
else
cat >> $JCLNAME << EOF
//COWOLJCL    JOB 1,NOTIFY=&SYSUID
//COWOLIGY   EXEC IGYWCL
//COBOL.SYSIN  DD DSN=&SYSUID..SOURCE($DESTNAME),DISP=SHR
//LKED.SYSLMOD DD DSN=&SYSUID..LOAD($DESTNAME),DISP=SHR
// IF RC = 0 THEN
//COWOLRUN EXEC PGM=$DESTNAME
//STEPLIB  DD DSN=&SYSUID..LOAD,DISP=SHR
//SYSOUT   DD SYSOUT=*
//CEEDUMP  DD DUMMY
//SYSUDUMP DD DUMMY
// ELSE
// ENDIF
EOF
fi

ansible-playbook "$(dirname $0)/../submit_jcl.yml" \
    --extra-vars "cowol_jcl=$JCLNAME"

rm -f $JCLNAME
