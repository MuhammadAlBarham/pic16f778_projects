#include<P16f84A.inc>
;Exersice 1 on Exp. 3 :Maplab Basics 
GPR equ 0x0D  ;assign GPR to Adress 0x0D 
movlw 0 
movwf GPR 
movf GPR,1 
nop 
nop 
end 