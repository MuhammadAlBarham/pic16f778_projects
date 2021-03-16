               		;Question 6 :
Loc30 equ 0x30 		;Define the Address 0x30 for Loc301
Loc40 equ 0x40 		;Define the Address 0x40 for Loc301
Status equ 0x3 		;Define the Address 0x3  for Status
movlw D'15'
movwf Loc30	
movlw D'0'
movwf Loc40
Start  				;The label that is used to make loop 
					;The First Equation :Loc30 = Loc30 – Loc40
movf  Loc40,0 		;Move the value of Loc40 To the W-reg 
subwf Loc30,1 		;Subtract the Loc40 from Loc30 and store the result in Loc30
					;The Second Equation :Loc40 = Loc40 + 1
 incf Loc40,1  		;Increament the Loc40 By 1 
movf Loc30,1  		;Mov the Loc30 to itself to Check the Zero flage 
btfsc Status,2 		;Check the zero flag Register 
goto Finish   		;If z=1 end the programme ; That is mean the value of Loc30 = 0
goto Start    		;If z=0 go to Start ; That is mean the value of Loc30 != 0
Finish 
nop 
end 



