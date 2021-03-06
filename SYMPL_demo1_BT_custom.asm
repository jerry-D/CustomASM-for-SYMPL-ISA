;SYMPL 128-bit Compute Engine Demo for real-time monitor/debugger
;BlueTooth version 1.02 Copyright August 30, 2021 by Jerry D. Harthcock.
;This program may be freely downloaded, modified, copied and distributed
;provided that this copyright notice is not removed.

;This assembler source is written for use with the open-source CustomASM cross-assembler
;Open-Source CustomASM rules-based cross-assembler is available for free download at:
;     github.com/hlorenzi/customasm

;(this version uses ":" and "=" in the ISA syntax
                  
#include "SYMPLrules.tbl"
            
timer            =  0x7FEC   ;32-bit timer current count value read-only --always cleared to 0 when timerCmpr is written to
timerCmpr        =  0x7FEC   ;32-bit timer compare register (at same address) write-only

timer_copy       =  0x0010   ;copy timer here so it can be read in bytes 
prevPlot         =  0x0020   ;pointer to the previous plot
curntPlot        =  0x0030   ;pointer to the image to plot
outBuf           =  0x0220
cout             =  0x0230
inChar           =  0x0231
LEDreg           =  0x7F84
buttons          =  0x7F85   ;buttons 6,5,4,3,2,1....  1 is LSB
artRdr           =  0x7FB0   ;ART receive data register
artTdr           =  0x7FB0   ;ART transmit data register
artStat          =  0x7FB1   ;ART status register
artCntrl         =  0x7FB2   ;ART control register
artRxClkDiv      =  0x7FB3   ;ART clockDivide register
TDRE             =  5        ;bit position for TDRE flag
RDRF             =  4        ;bit position for RDRF flag

_01_barchart_plt =  0x0600
_09_wizard_plt   =  0x0800
baz_plt          =  0x0A00
dmaker_plt       =  0x0C00
ocpred_tek       =  0x0E00
sixcharts_plt    =  0x1000
teklogo_plt      =  0x1200
gsxbasic1_plt    =  0x1400


Constants: 
 
prog_entry:       #d64 start      ;entry point for this program
prog_len:         #d64 progend    ;the present convention is location 0x00001 is the program/thread length

#addr             0x0100


start:  _    _4:timerCmpr = _4:#0xFFFFFFFF
        _    _4:SP = _4:#0x1FE0                   ;allow for 256-bit push if need be
        _    _1:clrDVCNZ = _1:#DoneBit            ;clear the Done bit to enable timer
        _    _2:artRxClkDiv = _2:#108             ;set baud rate for 12.5MHz clock / 115200 baud = 109 rounded up, subtract 1 = 108  
;        _    _1:artCntrl = _1:#0x01              ;set serial format for 8 data bits, 1 stop bit, no parity
        _    _1:artCntrl = _1:#0x02               ;set serial format for 8 data bits, 2 stop bit, no parity
        
        _    _4:AR0 = _4:#{demoMenu | 0x80000000} ;point to demo menu
        _    _4:PCC = (_1:0, 0, sendMessage)      ;branch always to sendMessage subroutine
        _
        _    _4:AR0 = _4:#{tekPlotMode | 0x80000000}  ;pop up the Tek window to draw on     
        _    _4:PCC = (_1:0, 0, sendMessage)      
        _
        _    _4:AR0 = _4:#{tekNorm | 0x80000000}  ;switch back to Normal (target) display buffer to put the cursor back in main window
        _    _4:PCC = (_1:0, 0, sendMessage)      ;branch always to sendMessage

        _    _4:prevPlot = _4:#{line1 | 0x80000000}
        
        
demoLoop:    _
        _
            
        _    _4:PCC = (_1:0,0, getChar)
        _
        _    _4:AR0 = _4:#{hiLiteOff | 0x80000000}
        _    _4:PCC = (_1:0, 0, sendMessage)      
        _    _1:compare = (_1:inChar, _1:#"1")
        _
        _    _4:PCS = (_1:STATUS, Z, draw1)
        _    _1:compare = (_1:inChar, _1:#"2")
        _
        _    _4:PCS = (_1:STATUS, Z, draw2)
        _    _1:compare = (_1:inChar, _1:#"3")
        _
        _    _4:PCS = (_1:STATUS, Z, draw3)
        _    _1:compare = (_1:inChar, _1:#"4")
        _
        _    _4:PCS = (_1:STATUS, Z, draw4)
        _    _1:compare = (_1:inChar, _1:#"5")
        _
        _    _4:PCS = (_1:STATUS, Z, draw5)
        _    _1:compare = (_1:inChar, _1:#"6")
        _
        _    _4:PCS = (_1:STATUS, Z, draw6)
        _    _1:compare = (_1:inChar, _1:#"7")
        _
        _    _4:PCS = (_1:STATUS, Z, draw7)                                             
        _    _1:compare = (_1:inChar, _1:#"8")                                          
        _
        _    _4:PCS = (_1:STATUS, Z, draw8)
        _    _4:PCC = (_1:0, 0, demoLoop)
        _
                               
        
draw1:  _    _4:AR0 = _4:prevPlot 
        _    _4:PCC = (_1:0, 0, sendMessage)  

        _    _4:prevPlot = _4:#{line1 | 0x80000000}
        _    _4:AR0 = _4:#{hiLiteOn | 0x80000000}
        _    _4:PCC = (_1:0, 0, sendMessage)      
        _
        _    _4:AR0 = _4:#{line1 | 0x80000000}
        _    _4:PCC = (_1:0, 0, sendMessage)      
        _
        _    _4:AR6 = _4:#{_01_barchart_plt | 0x80000000}  
        _    _4:PCC = (_1:0, 0, sendTekMsg)    
        _    _4:PCC = (_1:0, 0, demoLoop)
        _      
draw2:  _    _4:AR0 = _4:prevPlot 
        _    _4:PCC = (_1:0, 0, sendMessage)  
        
        _    _4:prevPlot = _4:#{line2 | 0x80000000}
        _    _4:AR0 = _4:#{hiLiteOn | 0x80000000}
        _    _4:PCC = (_1:0, 0, sendMessage)      
        _
        _    _4:AR0 = _4:#{line2 | 0x80000000}
        _    _4:PCC = (_1:0, 0, sendMessage)      
        _
        _    _4:AR6 = _4:#{_09_wizard_plt | 0x80000000}
        _    _4:PCC = (_1:0, 0, sendTekMsg)    
        _    _4:PCC = (_1:0, 0, demoLoop)
        _      
draw3:  _    _4:AR0 = _4:prevPlot 
        _    _4:PCC = (_1:0, 0, sendMessage)  
        
        _    _4:prevPlot = _4:#{line3 | 0x80000000}
        _    _4:AR0 = _4:#{hiLiteOn | 0x80000000}
        _    _4:PCC = (_1:0, 0, sendMessage)      
        _
        _    _4:AR0 = _4:#{line3 | 0x80000000}
        _    _4:PCC = (_1:0, 0, sendMessage)      
        _
        _    _4:AR6 = _4:#{baz_plt | 0x80000000}       
        _    _4:PCC = (_1:0, 0, sendTekMsg)    
        _    _4:PCC = (_1:0, 0, demoLoop)
        _      
draw4:  _    _4:AR0 = _4:prevPlot 
        _    _4:PCC = (_1:0, 0, sendMessage)  
        
        _    _4:prevPlot = _4:#{line4 | 0x80000000}
        _    _4:AR0 = _4:#{hiLiteOn | 0x80000000}
        _    _4:PCC = (_1:0, 0, sendMessage)      
        _
        _    _4:AR0 = _4:#{line4 | 0x80000000}
        _    _4:PCC = (_1:0, 0, sendMessage)      
        _
        _    _4:AR6 = _4:#{dmaker_plt | 0x80000000}      
        _    _4:PCC = (_1:0, 0, sendTekMsg)    
        _    _4:PCC = (_1:0, 0, demoLoop) 
        _     
draw5:  _    _4:AR0 = _4:prevPlot 
        _    _4:PCC = (_1:0, 0, sendMessage)  
        
        _    _4:prevPlot = _4:#{line5 | 0x80000000}
        _    _4:AR0 = _4:#{hiLiteOn | 0x80000000}
        _    _4:PCC = (_1:0, 0, sendMessage)      
        _
        _    _4:AR0 = _4:#{line5 | 0x80000000}
        _    _4:PCC = (_1:0, 0, sendMessage)      
        _
        _    _4:AR6 = _4:#{ocpred_tek | 0x80000000}      
        _    _4:PCC = (_1:0, 0, sendTekMsg)    
        _    _4:PCC = (_1:0, 0, demoLoop) 
        _     
draw6:  _    _4:AR0 = _4:prevPlot 
        _    _4:PCC = (_1:0, 0, sendMessage)  
        
        _    _4:prevPlot = _4:#{line6 | 0x80000000}
        _    _4:AR0 = _4:#{hiLiteOn | 0x80000000}
        _    _4:PCC = (_1:0, 0, sendMessage)      
        _
        _    _4:AR0 = _4:#{line6 | 0x80000000}
        _    _4:PCC = (_1:0, 0, sendMessage)      
        _
        _    _4:AR6 = _4:#{sixcharts_plt | 0x80000000}   
        _    _4:PCC = (_1:0, 0, sendTekMsg)    
        _    _4:PCC = (_1:0, 0, demoLoop)  
        _    
draw7:  _    _4:AR0 = _4:prevPlot 
        _    _4:PCC = (_1:0, 0, sendMessage)  
        
        _    _4:prevPlot = _4:#{line7 | 0x80000000}
        _    _4:AR0 = _4:#{hiLiteOn | 0x80000000}
        _    _4:PCC = (_1:0, 0, sendMessage)      
        _
        _    _4:AR0 = _4:#{line7 | 0x80000000}
        _    _4:PCC = (_1:0, 0, sendMessage)      
        _
        _    _4:AR6 = _4:#{teklogo_plt | 0x80000000}     
        _    _4:PCC = (_1:0, 0, sendTekMsg)    
        _    _4:PCC = (_1:0, 0, demoLoop)
        _      
draw8:  _    _4:AR0 = _4:prevPlot 
        _    _4:PCC = (_1:0, 0, sendMessage)  
        
        _    _4:prevPlot = _4:#{line8 | 0x80000000}
        _    _4:AR0 = _4:#{hiLiteOn | 0x80000000}
        _    _4:PCC = (_1:0, 0, sendMessage)      
        _
        _    _4:AR0 = _4:#{line8 | 0x80000000}
        _    _4:PCC = (_1:0, 0, sendMessage)      
        _
        _    _4:AR6 = _4:#{gsxbasic1_plt | 0x80000000}   
        _    _4:PCC = (_1:0, 0, sendTekMsg)    
        _    _4:PCC = (_1:0, 0, demoLoop)      
                               

sendMessage: _
        _    _4:*SP--[4] = _4:PC_COPY            ;save return address     

sendLoop:    _
        _    _4:AR1 = _4:#outBuf                 ;load AR1 with pointer to first character postion of outBuf
        _    s8:outBuf = _8:*AR0++[1]            ;place 8 characters from program ROM into outBuf -- swap endianess
        _    _2:LPCNT0 = _2:#8                   ;each program ROM location contains 8 characters
loopInner:   _
        _    _1:compare = (_1:*AR1[0], _1:#0x00) ;see if current char is a null character 
        _
        _    _1:cout = _1:*AR1++[1]              ;copy first char in buffer to cout and increment to next character
        _    _4:PCC = (_1:STATUS, Z, sendChar)   ;if not null then send it
        _    _4:PCS = (_1:STATUS, Z, clrLPCNT)   ;else exit if null char
        _    _4:PCS = (_4:LPCNT0, 16, loopInner) ;next  
        _    _4:PCC = (_1:0, 0, sendLoop)        ;branch always to sendLoop 
            
clrLPCNT:    _   
       _     _4:PC = _4:*SP++[4]                 ;restore PC (return)

sendTekMsg:  _
       _     _4:*SP--[4] = _4:PC_COPY            ;save return address
              
       _     _4:AR0 = _4:#{tekPlotMode | 0x80000000}   ;switch to Tektronix mode    
       _     _4:PCC = (_1:0, 0, sendMessage) 
       _ 
       
sendTekLoop: _
       _     _4:AR1 = _4:#outBuf               
       _     _8:outBuf = _8:*AR6++[1]          
       _     _2:LPCNT0 = _2:#8                 
loopTekInner: _ 
       _     _1:compare = (_1:*AR1[0], _1:#0x00)    ;see if current char is a null character 
       _
       _     _1:cout = _1:*AR1++[1]                 ;copy first char in buffer to cout and increment to next character
       _     _4:PCC = (_1:STATUS, Z, sendChar)      ;if not null then send it
       _     _4:PCS = (_1:STATUS, Z, clrTekLPCNT)   ;else exit if null char
       _     _4:PCS = (_4:LPCNT0, 16, loopTekInner) ;next  
       _     _4:PCC = (_1:0, 0, sendTekLoop)        ;branch always to sendLoop 
            
clrTekLPCNT: _  
       _     _4:AR0 = _4:#{tekNorm | 0x80000000}    ;switch back to Normal (target) display buffer
       _     _4:PCC = (_1:0, 0, sendMessage)        ;branch always to sendMessage
       _
       _     _4:PC = _4:*SP++[4]                    ;restore PC (return)
            
            
sendChar:    _
       _     _4:*SP--[4] = _4:PC_COPY                 
waitTDRE:    _ 
       _     _4:PCC = (_1:artStat, TDRE, waitTDRE)  ;wait for TDRE to become 1 if not already 1
       _
       _     _4:AR2 = _4:#0
       _     _2:REPEAT = _2:#108                    ;roughly 1 bit time
       _     _1:*AR2++[0] = _1:#0                   ;delay specified amount to give time
                                                    ;for TEK rendering to do its thing
       
       _     _1:artTdr = _1:cout                    ;send it
       
       _     _4:PC = _4:*SP++[4]                    ;restore PC (return)

getChar:     _
       _     _4:*SP--[4] = _4:PC_COPY                
waitRDRF:    _
       _     _1:LEDreg = _1:buttons                 ;capture buttons and write them to LEDs

       _     _4:PCC = (_1:artStat, RDRF, waitRDRF)
       _     _1:inChar = _1:artRdr                
       _     _4:PC = _4:*SP++[4]                 
       _
       _
       _
       _
       _
       _
       _
       _
       _
            
            

hiLiteOn:     #d  0x1b,"[48;5;94m", 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
hiLiteOff:    #d  0x1b,"[48;5;0m", 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

tekPlotMode:  #d   0x1b,"[?38h",0x1b, 0x0C, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00    ;also clears the screen
tekNorm:      #d   0x1b,0x03, 0x1b,"[25;9H", 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00    ;esc CNTRL-C leaves TEK and enters VT100 Normal mode        

line1:        #d   0x1b,"[16;23H[1] 01_barchart.plt",0x1b,"[48;5;0m", 0x00, 0x00, 0x00, 0x00                                                         
line2:        #d   0x1b,"[17;23H[2] 09_wizard.plt  ",0x1b,"[48;5;0m", 0x00, 0x00, 0x00, 0x00                                                   
line3:        #d   0x1b,"[18;23H[3] baz.plt        ",0x1b,"[48;5;0m", 0x00, 0x00, 0x00, 0x00
line4:        #d   0x1b,"[19;23H[4] dmaker.plt     ",0x1b,"[48;5;0m", 0x00, 0x00, 0x00, 0x00
line5:        #d   0x1b,"[20;23H[5] ocpred.tek     ",0x1b,"[48;5;0m", 0x00, 0x00, 0x00, 0x00
line6:        #d   0x1b,"[21;23H[6] sixcharts.plt  ",0x1b,"[48;5;0m", 0x00, 0x00, 0x00, 0x00
line7:        #d   0x1b,"[22;23H[7] teklogo.plt    ",0x1b,"[48;5;0m", 0x00, 0x00, 0x00, 0x00
line8:        #d   0x1b,"[23;23H[8] gsxbasic1.plt  ",0x1b,"[48;5;0m", 0x00, 0x00, 0x00, 0x00

demoMenu:     #d   0x1b,"[?47l",0x1b,"[2J",0x1b,"[2;1H"
              #d   "                   SYMPL COMPUTE ENGINE DEMO", 0x0D, 0x0A
              #d   "         Tektronix 4010 plots courtesy of Rene Richarz.", 0x0D, 0x0A, 0x0A 
              #d   " Tektronix and logo are registered trademarks of Tektronix, Inc.", 0x0D, 0x0A                           
              #d   " The plots for this demo can be downloaded from the link below:", 0x0D, 0x0A                         
              #d   "                   github.com/richarz/TEK4010", 0x0D, 0x0A, 0x0A, 0x0A, 0x0A, 0x0A 
              #d   "                            M E N U", 0x0D, 0x0A, 0x0A                  
              #d   "       Press on key number corresponding to desired image.", 0x0D, 0x0A, 0x0A                           
              #d   "                      [1] 01_barchart.plt", 0x0D, 0x0A                                                         
              #d   "                      [2] 09_wizard.plt  ", 0x0D, 0x0A                                                         
              #d   "                      [3] baz.plt        ", 0x0D, 0x0A 
              #d   "                      [4] dmaker.plt     ", 0x0D, 0x0A 
              #d   "                      [5] ocpred.tek     ", 0x0D, 0x0A 
              #d   "                      [6] sixcharts.plt  ", 0x0D, 0x0A 
              #d   "                      [7] teklogo.plt    ", 0x0D, 0x0A 
              #d   "                      [8] gsxbasic1.plt  ", 0x0D, 0x0A, 0x0A
              #d   " Number:",0x00, 0x00, 0x00, 0x00, 0x00, 0x00                                                                     
                                                                                                                         
progend:                                                                                                                       
