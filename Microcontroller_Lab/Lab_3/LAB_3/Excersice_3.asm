#include <P16F84A.inc>
movlw 5         ; Assign the value 5 to 0x33 register 
movwf 0x33 
movlw 8         ; Assign the value 5 to 0x11 register
movwf 0x11 
                ; I use a new register to save the value of 0x0E 
movf 0x33,0 
movwf 0x0C 

movf 0x11,0
movwf 0x33 

movf 0x0c,0 
movwf 0x11


nop 
nop 
nop 
end 
