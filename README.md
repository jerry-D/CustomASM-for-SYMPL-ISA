## CustomASM Support for SYMPL Universal Floating-Point ISA
SYMPL ISA Rule table for open-source CustomASM cross-assembler.


(July 19, 2023) The SYMPLrules.tbl file has been updated as Version 1.02 and believed to now be error-free.  Also, the assembler output modes are explained here.  There are now four output modes that may be specified in the assembler batch file:

annotatedhex -- used for generating traditional object listing comprising lables, Program Counter [address] value, 64-bit hex value for instruction/data field, and source text, but does not include comment text

annotated    -- same as annotatedhex, except the output does not include the 64-bit hex value for the instruction field in the listing output.  This is useful for on-chip, source level debuggers

binary       -- executable binary image

hexdump      -- contains only the contiguous 64-bit values in ASCII hex, which is useful for initializing FPGA RAM blocks used for target program memory during Verilog simulation and synthesis stages.

Usage examples:
```
:: use the following command to output a object listing file
customasm -f annotatedhex -o SYMPL_demo1_BT_custom.obj SYMPL_demo1_BT_custom.asm
 
:: use the following command to output a executable binary file that can be uploaded to the target
customasm -f binary -o SYMPL_demo1_BT_custom.bin SYMPL_demo1_BT_custom.asm

:: use the following command to output a source-only listing file that can be uploaded to the debugger
customasm -f annotated -o SYMPL_demo1_BT_custom.src SYMPL_demo1_BT_custom.asm
 
:: use the following command to produce a 64-bit wide hex file that can be used by Verilog $readmemh system task for initializing FPGA ROM
customasm -f hexdump -o SYMPL_demo1_BT_custom.ini SYMPL_demo1_BT_custom.asm

```
In addition to the updated SYMPLrules.tbl file, the modified CUSTOMASM source files, customasm.exe executable, and copy of the pertinent Apache license have also been added to this repository.

(August 31, 2021) The repository has been updated to include source with ":" and "=" characters in the target ISA syntax.  However, to assemble it, you will first need to clone the CustomASM repository and add two lines of code to the CustomASM file: source/syntax/token.rs within the "is_allowed_pattern_token" function by including the following lines among the others:
```
	self == TokenKind::Equal ||          //added by J.D.H. 8/31/2021
	self == TokenKind::Colon ||          //added by J.D.H. 8/31/2021
  
```  
Then you will need to install Rust and re-compile the modified code.  Once you modify the above file, run "cargo build" command to a create new customASM executable, which will be located in the your rust target/debug/ folder.  

Assuming the official CustomASM repository eventually will incorporate the above modification to allow use of ":" and "=" in the target ISA syntax, I will publish a notice to that effect so you won't have to build your own version of it.

(August 30, 2021) This repository contains a Rule table that can be used with the open-source CustomASM rule-based cross-assembler to assemble SYMPL ISA assembly language source files whose binary output can be uploaded to the ULX3S FPGA board.  Also available at this repository is a version of the Blue Tooth version of the SYMPL IEEE 754-2019 demo that has been modified to conform to the current CustomASM syntax.  The source and assembled files are:
```
SYMPL_demo1.bat               //MSDOS batch file for executing CustomASM to generate listing file and executable binary file
SYMPL_demo1_BT_custom.asm     //assembly source file converted for use with CustomASM syntax
SYMPL_demo1_BT_custom.hex     //assembled binary executable that can be uploaded to ULX3S FPGA board
SYMPL_demo1_BT_custom.lst     //assembled listing file generated by CustomASM
SYMPL_demo1_BT_custom.sym     //symbol file generated by CustomASM
SYMPLrules.tbl                //SYMPL ISA Rules table for use with CustomASM
```
To download your free copy of the open-source CustomASM, visit:  

https://github.com/hlorenzi/customasm

For more information on the SYMPL Universal Floating-Point ISA, refer to the following documents:

https://github.com/jerry-D/SYMPL_IEEE754-2019_ISA/blob/main/UFP_ISA.pdf

https://github.com/jerry-D/HedgeHog-Fused-Spiking-Neural-Network-Emulator-Compute-Engine/blob/master/HedgeHog.pdf

https://github.com/jerry-D/64-bit-Universal-Floating-Point-ISA-Compute-Engine/blob/master/SYMPL_neuron16c.pdf


