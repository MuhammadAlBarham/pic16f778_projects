
include "p16F84A.inc"
cblock 0x25
testNum1
testNum2 
Result
endc
org 0x00
Main
movf testNum1,0
subwf testNum2,0
movwf Result 
btfsc STATUS,2
goto Equal 

btfsc STATUS,0 
goto Greater 
goto Smaller 

Greater 
movlw A'G'
movwf Result 
goto Finish 

Smaller
movlw A'S'
movwf Result 
goto Finish 

Equal 
movlw A'E' 
movwf Result 

Finish 

nop 
end  

 
