loc1 equ 0x11 
loc2 equ 0x33 
loc3 equ 20 
movlw 5 
movwf loc1 
movlw 4 
movwf loc2 
movf loc2,0
movwf loc3 
movf loc1,0
movwf loc2 
movf loc3,0
movwf loc1
nop
end 