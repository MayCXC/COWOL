#!/bin/sh

export ANSIBLE_CONFIG="$(dirname $0)/../ansible.cfg"

. ~/.profile

WSLNAME=$1
if command -v wslpath >/dev/null 2>&1
then
WSLNAME=$(wslpath $WSLNAME)
fi

SRCNAME=$(realpath $WSLNAME)
DESTNAME=$(basename $WSLNAME | cut -d. -f1 | cut -c -8 | tr [:lower:] [:upper:])

ansible-playbook "$(dirname $0)/../submit_source.yml" \
    --extra-vars "cowol_src=$SRCNAME cowol_dest=$DESTNAME"

JCLNAME=$(mktemp)
if [ ! -z "$2" ]
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
//STEPLIB    DD DSN=&SYSUID..LOAD,DISP=SHR
//SYSOUT     DD SYSOUT=*
//CEEDUMP    DD DUMMY
//SYSUDUMP   DD DUMMY
// ELSE
// ENDIF
EOF
fi

ansible-playbook "$(dirname $0)/../submit_jcl.yml" \
    --extra-vars "cowol_jcl=$JCLNAME"

rm -f $JCLNAME
