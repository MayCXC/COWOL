# COWOL
### CObol WithOut Leave
Are you tired of editing COBOL programs in Zowe explorer, just to accidentally submit your source member as a batch job? Last time that happened to me, I smashed my keyboard so hard that this repository typed itself out.

**COWOL** builds and tests Enterprise COBOL right from VSCode. You can open a COBOL program in the COWOL VSCode workspace, and press **ctrl + shift + B** to see several different build tasks. All of them use the **ibm_zos_core** ansible collection to copy your program to **&SYSUID.SOURCE** and compile it with **IGYWCL**, either using a minimal default JCL, or another custom JCL in the workspace. You then have the option to run the load module with **JES** and retrieve its output in a terminal, or to start an interactive TSO address space and run it with **SYSIN** and **SYSOUT** allocated to a terminal. You can also use the TSO terminal to debug your load module with the **TEST** command, and for completeness there is a build task to copy and run a REXX exec in it.

All of the build tasks that use TSO also share the same terminal and the same presentation group, so they only need to run one TSO address space at a time, and you never need to click the VSCode terminal dropdown. Alternatively, you can just use `cowol/tsoterm.sh` as a standalone interactive TSO terminal by pressing **ctrl + shift + P** and selecting **Tasks: Run Task > Start interactive TSO address space** in the command pallette. It will read TSO input from STDIN until you kill it with SIGUSR1, then it will read TSO input from a temporary FIFO that other programs can pipe into. The PID and FIFO path are both stored in `cowol/.tsolock`, which additional instances will use to redirect their input, so that TSO commands only ever run on one terminal. Pressing **ctrl+C** will make `tsoterm.sh` clean up the lock, fifo, and address space, and exit.

## REQUIREMENTS
Docker with `masterthemainframe/ansible:latest`, VSCode with Zowe explorer, and a terminal with Zowe CLI and any superset of the Bourne shell.

## INSTALLATION
Start by cloning this repository and copying its contents into the `masterthemainframe/ansible` container from ANSB2:

Alternatively, copy the project structure from `masterthemainframe/ansible` into this repository in an environment that can run the playbooks:

Finally, open the repository in VSCode.

## INSTRUCTIONS
You can run `source/fizzbuzz.cob` by pressing **ctrl + shift + B** and selecting **Run COBOL with default JCL**.

You can also run `source/hellocbl.cob` with the **Run COBOL with custom JCL** build task. You can respond to the **Path to custom JCL** prompt with `./hellocbl.jcl`, but the default path will also work because the .cob and .jcl share the same filename.

You can also run `source/hellotso.cob` with the **Run COBOL with interactive TSO AS** build task, or with the custom JCL build task, to see examples of both interactive and in-stream SYSIN.

Finally, you can run `source/ping.rexx` with the **Run REXX with interactive TSO AS** build task, and it will either reuse the same TSO terminal if you left it open, or open a new one if you closed it.

## DESCRIPTIONS


## ENDGAME
All the functionalities of this project would be better off as additions to the Zowe explorer plugin, instead of as a VSCode profile. So, useful would Zowe explorer pull request. That being said, this approach demonstrates that achieved with the vanilla IDE, which could be useful in circumstances where developers are using inconsistent working environments. Thank you for your consideration.
