#include "p16F84A.inc"
cblock 0x25 
test  ; The Input Number 	
test1 ; The Number After Swapping
MSB   ; The most Nibble 	
LSB   ; The Least Nibble 
Result ; The Result of the Check
endc 
; Here An Example to This Code :
;test =0x49  
;Using Bit clear to get MSB and LSB 
swapf test,0
movwf test1 
bcf test,4
bcf test,5
bcf test,6
bcf test,7 

bcf test1,4
bcf test1,5
bcf test1,6
bcf test1,7 

movf test,0
movwf LSB 
movf test1,0
movwf MSB 
movf LSB,0

subwf MSB,0     ; Sub MSB-LSB		
                 ; Example : 0xN1N2
                 ; Where N1:Most Nibble & N2:Least Nibble 
                 ;  if N1>N2  result G 'Greater'
                 ;  if N2<N1  result S 'Smaller'
                 ;  if N2=N1  result E 'Equal'  

btfsc 0x03,2         ; 0x03 is the Address of the Status Register , 0 is the Carry  Bit  
goto Equal 

btfsc 0x03,0         ; 0x03 is the Address of the Status Register , 0 is the carrry Bit  
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
