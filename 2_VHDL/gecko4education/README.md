# Description - Gecko4Education Board Build Template

**Company**
 :  Bern University of Applied Sciences

**Purpose**
 :  This file contains the template files for Gecko4Education Board

**Author**
 :  Andreas HABEGGER <andreas.habegger@bfh.ch>

**Date**
 :  8.04.2016

___
Prerequisite
---
The build system relays on bsc-course-template directory. Make sure you got a copy of this repository first. The copy must be located in upper folder hence on same level as this project directory. Run the command below for clarification. The soft links reference bsc-course-repository
```
ls -la
```

HowTo use
---
The template is based on Makefiles. The Makefiles are managed by **bsc-course-template**, that's why it is a prerequisite. Use make without any dialogue to get an information dialogue concerning available options.

```
make
```
___
Structure of Directory
---
### config/

This folder contains configuration files as well as simulation stimuli, selection of source files, and a file that references the top module. Analyze files in that folder. 

### vhdl/

In this location we keep the VHDL source files. There are all files such as entity, architecture, packages etc.

### tcl/

This folder contains TCL files. This files are needed for Altera workflow and ignored for Xilinx. The TCL files are used in different situations such as for pin assignment, port configuration etc. The file and its content should be self-explaining.

### sandbox/

This folder contains data generated form several input files. If you archive the project remove that folder first there are temporary files only.
___






