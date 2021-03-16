Include "p16F84A.inc"
; ----------------------------------------------------------
; General Purpose RAM Assignments
; ----------------------------------------------------------
cblock		0x0C	
Counter
Endc

; ----------------------------------------------------------
; Macro Definitions
; ----------------------------------------------------------
Read_EEPROM	macro
Bcf             STATUS, RP0    ;Go to Bank 0 
Clrf             EEADR         ;Clear EEADR (EEADR=0)
Bsf              STATUS, RP0   ;Go to Bank 1 
Bsf              EECON1, RD    ;Begin Read 
Bcf              STATUS, RP0   ;Go to Bank 0 
Endm
; ----------------------------------------------------------
; Vector definition
; ----------------------------------------------------------
			org 0x000
			nop
			goto Main
		
INT_Routine	org 0x004
		goto INT_Routine
; ----------------------------------------------------------
; The main Program
; ---------------------------------------------------------- 
	Main
Read_EEPROM
	Clrf        Counter          ;Clear the counter 
	Bsf         STATUS, RP0      ;Go to Bank 1 
	Clrf		TRISB            ;Make PORTB as OUTPUT
	Bcf         STATUS, RP0      ;Go to BANK 0
	Movlw		A'H'             ;Move Character to W-Reg
	Subwf		EEDATA,w         ;Check If the first char. is H 
	Btfsc		STATUS,Z         ;If Yes goto finish 
	Goto		Finish
	Incf		Counter,f         
	Movlw		A'M'
	Subwf		EEDATA,w
	Btfsc		STATUS,Z
Finish	
	Incf	Counter,f
	Call		Look_Up
	Movwf		PORTB
Loop
	Goto		Loop
	
; ----------------------------------------------------------
; Sub Routine Definitions
; ----------------------------------------------------------
;This Look_Up table for 7-Seg. Display 
Look_Up  
Movf       	Counter,w  
Addwf     	PCL,f       
Retlw       B'00111111' 	; Number 0 
Retlw       B'00000110' 	; Number 1
Retlw       B'01011011' 	; Number 2
Retlw       B'01001111' 	; Number 3
Retlw       B'01100110' 	; Number 4
Retlw       B'01101101' 	; Number 5

end				
