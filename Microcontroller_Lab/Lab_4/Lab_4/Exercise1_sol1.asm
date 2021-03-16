#include "p16F84A.inc"
cblock 0x25 
test1 
Result 
endc 

movf test1,0
swapf test1,0
subwf test1,0

btfsc 0x03,2 
goto Equal 

btfsc 0x03,0
goto Greater 
goto Smaller 

Greater 
movlw A'G'
movwf Result 
goto Finish 

Equal 
movlw A'E' 
movwf Result 
goto Finish 

Smaller 
movlw A'S' 
movwf Result 
goto Finish 

Finish 
nop 
end 
