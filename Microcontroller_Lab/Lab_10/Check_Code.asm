	include "p16f877A.inc"
;User-defined variables

	cblock	0x20
		WTemp			; Must be reserved in all banks
		D_val 
		A_val		
	endc
org 0x00 
nop 


call  D_A_Convert
goto  finish 

D_A_Convert

movf 	D_val,0 
sublw 	D'25'
btfsc	STATUS,C
retlw 	D'0'

movf 	D_val,0 
sublw 	D'76'
btfsc	STATUS,C
retlw 	D'1'

movf 	D_val,0 
sublw 	D'127'
btfsc	STATUS,C
retlw 	D'2'

movf 	D_val,0 
sublw 	D'178'
btfsc	STATUS,C
retlw 	D'3'

movf 	D_val,0 
sublw 	D'229'
btfsc	STATUS,C
retlw 	D'4'

movf 	D_val,0 
sublw 	D'255'
btfsc	STATUS,C
retlw 	D'5'

retlw   D'0'
 

finish 

nop 
nop 

	end
