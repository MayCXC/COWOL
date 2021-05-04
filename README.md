# COWOL
### CObol WithOut Leave
Are you tired of editing COBOL programs in Zowe explorer, just to accidentally submit your source member as a batch job? Last time that happened to me, I smashed my keyboard so hard that this repository typed itself out.

**COWOL** builds and tests Enterprise COBOL right from VSCode. You can open a COBOL program in the COWOL VSCode workspace, and press **ctrl + shift + B** to see several different build tasks. All of them use the **ibm_zos_core** ansible collection to copy your program to **&SYSUID.SOURCE** and compile it with **IGYWCL**, either using a minimal default JCL, or another custom JCL in the workspace. You then have the option to run the load module with **JES** and retrieve its output in a display terminal, or to start a TSO address space and run the load module with **SYSIN** and **SYSOUT** allocated to an interactive terminal. You can also use the address space to debug your load module with the **TEST** command, and for completeness there is a build task to copy and run a REXX exec in it.

All of the build tasks that use TSO also share the same terminal and the same presentation group, so they only need to run one TSO address space at a time, and you never need to click the terminal dropdown. You can also just use `cowol/tsoterm.sh` as a standalone TSO terminal, by pressing **ctrl + shift + P** and selecting **Tasks: Run Task > Start interactive TSO address space** in the command pallette. It will read TSO input from STDIN until you kill it with SIGUSR1, then it will read TSO input from a temporary FIFO that other programs can pipe into. The PID and FIFO path are both stored in `cowol/.tsolock`, which additional instances will redirect their input to, so that TSO commands only ever run on one terminal. Pressing **ctrl + C** will make `tsoterm.sh` clean up the lock, fifo, and address space, and exit.

## REQUIREMENTS:
- Docker with `masterthemainframe/ansible:latest`
- VSCode with Zowe explorer and a zOSMF profile
- a terminal with Zowe CLI and any superset of the Bourne shell

## INSTALLATION:
Start by [clicking here](https://github.com/mayhd3/COWOL/archive/main.zip) to download the COWOL VSCode workspace. Extract it and copy its contents into the `masterthemainframe/ansible` container from ANSB1, `suspicious_noyce` was the name of mine:

```
unzip COWOL-main.zip
docker cp COWOL-main suspicious_noyce:/root/
exec -it suspicious_noyce sh
cp COWOL-main/* .
```

Alternatively, copy the project structure from `masterthemainframe/ansible` into this repository in an environment that can run the playbooks:

```
unzip COWOL-main.zip
cd COWOL-main
docker cp suspicious_noyce:/root/group_vars .
docker cp suspicious_noyce:/root/inventory .
docker cp suspicious_noyce:/root/.ansible/collections/ansible_collections/ .
```

Finally, open the workspace in VSCode, either by attaching to the container, or by opening the folder you copied the ansible project into.

## INSTRUCTIONS:
You can run `source/fizzbuzz.cob` by pressing **ctrl + shift + B** and selecting **Run COBOL with default JCL**.

You can also run `source/hellocbl.cob` with the **Run COBOL with custom JCL** build task. You can respond to the **Path to custom JCL** prompt with `./hellocbl.jcl`, but the default path will also work because the .cob and .jcl share the same filename.

You can also run `source/hellotso.cob` with the **Run COBOL with interactive TSO AS** build task, or with the custom JCL build task, to see examples of both interactive and in-stream SYSIN.

You can also run `source/ping.rexx` with the **Run REXX with interactive TSO AS** build task, and it will either reuse the same TSO terminal if you left it open, or open a new one if you closed it.

Finally, you can run `source/topaccts.cbl` with the custom JCL build task. This is the program from CBL1, included just so that I can get COBOL to show up in my pinned repos.

## DESCRIPTIONS:

```
cowol
├── jclcobol.sh: runs a given or default JCL for a COBOL program using submit.sh and submit_jcl.yml
├── submit.sh: copies a source member to the SOURCE dataset using submit_source.yml
├── tsocobol.sh: compiles a COBOL program using jclcobol.sh, and runs it interactively using tsoterm.sh
├── tsorexx.sh: runs a REXX program using submit.sh and tsoterm.sh
└── tsoterm.sh: starts an interactive TSO session, acting as a server for STDIN and a temporary named pipe
source
├── fizzbuzz.cob: just the classic fizzbuzz, one through one hundred
├── hellocbl.cob: bootleg of a similar program from REXX1
├── hellocbl.jcl: custom jcl with an input file dd statement
├── hellotso.cob: hello world with an ACCEPT statement
├── hellotso.jcl: compiles and runs hellotso with an in-stream input file
├── ping.rexx: GOTY 2020
├── topaccts.cob: program from the CBL1 challenge
└── topaccts.jcl: jcl to compile and run topaccts.cob
submit_jcl.yml: runs a batch process for a given JCL and retrieves ddname contents
submit_source.yml: copies a given file to the SOURCE dataset, truncating its name and return carriages
```
## IMPROVEMENTS:
COWOL successfully took all the clicking out of COBOL development with Zowe explorer, but an even better approach would be an addition to the plugin itself with a [Task Provider](https://code.visualstudio.com/api/extension-guides/task-provider), instead of project `tasks.json` entries. This would have the advantages of smarter task selection for different file extensions, and avoiding depending on `sh`, signals, pipes, and common albeit non-portable utilities like `tail` and `grep`. So, this would eventually be reified as a Zowe explorer pull request. That being said, this approach demonstrates what can be achieved with vanilla VScode, which could be useful in circumstances where developers are using inconsistent working environments. Finally, I want to say that this competition was a great learning experience, and thank you for your consideration.

# RESULT:
Success! I finished as [one of the regional winners for North America](https://community.ibm.com/community/user/ibmz-and-linuxone/blogs/meredith-stowell1/2021/03/31/announcing-the-2020-master-the-mainframe-winners), and have been scheduled for some ongoing interviews.
