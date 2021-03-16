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
Bcf             STATUS, RP0 
Clrf             EEADR
Bsf              STATUS, RP0
Bsf              EECON1, RD 
Bcf              STATUS, RP0 
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
	Clrf        Counter
	Bsf         STATUS, RP0
	Clrf		TRISB
	Bcf         STATUS, RP0
	Movlw		A'H'
	Subwf		EEDATA,w
	Btfsc		STATUS,Z
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
Look_Up
Movf       Counter,w
Addwf     PCL,f
Retlw       B'00111111'
Retlw       B'00000110'
Retlw       B'01011011'
Retlw       B'01001111'
Retlw       B'01100110'
Retlw       B'01101101'

end				
