#include "p16f84a.inc";initialize the library 
cblock 0x20           ;initialize the variable with addresses 
input1                ;GPR for the input1 
input2       		  ;GPR for the input2
tempinput2   		  ;GPR for the temporary input2 
counter       	 	  ;GPR for the counter ( counter = input2 /input1 )
reminder     		  ;GPR for the reminder of the division 
endc
;----------------------------------------------------


Main 
org 0x00              ; initialize the variables with zero value 
clrf reminder 
clrf counter 
clrf tempinput2
clrw 
muhammad 

; Check if input1 equal to zero 
movf input1,1 
btfsc STATUS,Z
goto finish 

; check if input1 < input2 
bcf STATUS,C
movf input1,W
subwf input2,W
btfss STATUS,C  
goto check              

movf input2,W         ; Save the value of input2 in tempinput2 
movwf tempinput2      ; to keep the value of the input2 

Again                 ; This code is for execution the counter of the equation 
movf  input1,W       
subwf tempinput2,W    ; if input1 > input2  (the tempinput2 equal to the reminder ) else continue 
btfss STATUS,C        ; Go to finish1 of the programme 
goto finish1          
movf input1,W         ; move input1 to W-Reg to subtract it from tempinput2 
incf counter,F        ; increment the counter by value equal to 1 
subwf tempinput2,F    
btfss STATUS,Z        ;Test for tempinput2 if Z=1 go to finish else continue 
goto Again 
clrf reminder         ;set the value of the reminder to equal to zero 
goto finish

finish1               ; Set the value of the reminder to equal to tempinput2  
movf tempinput2,W  
movwf reminder 
goto finish 

;-------------------------------------------------------
check 
movf input2,0
movwf reminder


finish 
nop 
end    