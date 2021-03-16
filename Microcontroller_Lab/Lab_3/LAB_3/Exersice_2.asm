#include<P16F84A.inc> 
movlw 5 
movwf 0X0E 
movf  0x0E,0 
movwf 0x1F 

nop 
nop 
nop 
end 
