# COWOL
### CObol WithOut Leave
Are you tired of editing COBOL programs in Zowe explorer, just to accidentally submit your member as a batch job? Last time that happened I smashed my keyboard so hard that this repository typed itself out.

## DEPENDENCIES
VSCode with Zowe explorer, docker with `masterthemainframe/ansible:latest`, a terminal with any POSIX compliant shell, and Zowe CLI.

## INSTALLATION
Start by copying the contents of this repository into the `ansible` container from ANSB2:
Alternatively, copy the contents of `ansible` into an environment that can run the playbooks:
Finally, open the folder in VSCode.

## INSTRUCTIONS
Now you can run fizzbuzz.cob by. This will work for any COBOL program with the provided JCL. You can also run hello.cob by. This will work for any COBOL program the provided CLIST. This allows for taking interactive TSO input from SYSIN, and to debugging the program with the TEST command.

## DESCRIPTIONS
### CLIST
### JCL
### submit_clist.yml
### submit_jcl.yml
### tsopipe.sh
### tsoterm.sh
### zosname.sh

## ENDGAME
All the functionalities of this project would be better off as additions to the Zowe explorer plugin, instead of as a VSCode profile. So, useful would Zowe explorer pull request. That being said, this approach demonstrates that achieved with the vanilla IDE, which could be useful in circumstances where developers are using inconsistent working environments. Thanks for your consideration.
