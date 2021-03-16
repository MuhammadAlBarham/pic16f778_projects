
include "p16F84A.inc"
cblock 0x25          ; This code compare between tow numbers 
testNum1             ; The first Number 
testNum2             ; The second Number
Result               ; The Result  
endc                 
org 0x00
Main
clrf Result 
clrw
movf  testNum1,0       ; Subtract testNum2 - testNum1 
subwf testNum2,0       ; If testNum2 >testNum1    Result equal G (Greater) 
                       ; If testNum2 <testNum1    Result equal S (Smaller)
btfsc STATUS,2         ; If testNum2 =testNum1    Result equal E (Equal)
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

 
