:: use the following command to output a object listing file
customasm -f annotatedhex -o SYMPL_demo1_BT_custom.obj SYMPL_demo1_BT_custom.asm
 
:: use the following command to output a executable binary file that can be uploaded to the target
customasm -f binary -o SYMPL_demo1_BT_custom.bin SYMPL_demo1_BT_custom.asm

:: use the following command to output a source-only listing file that can be uploaded to the debugger
customasm -f annotated -o SYMPL_demo1_BT_custom.src SYMPL_demo1_BT_custom.asm
 
:: use the following command to produce a 64-bit wide hex file that can be used by Verilog $readmemh system task for initializing FPGA ROM
customasm -f hexdump -o SYMPL_demo1_BT_custom.ini SYMPL_demo1_BT_custom.asm
