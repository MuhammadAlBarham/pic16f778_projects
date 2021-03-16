Include	"p16F84A.inc"
; ----------------------------------------------------------
; General Purpose RAM Assignments
; ----------------------------------------------------------
cblock		0x0C	

Endc

; ----------------------------------------------------------
; Macro Definitions
; ----------------------------------------------------------
;.
;.
;.
;.
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
Movlw       0x00
Movwf       EEADR
Movlw		A'M'
Bcf			STATUS,RP0
Movwf		EEDATA
Incf		EEADR,f
Bsf			 STATUS, RP0 
Bcf			 INTCON, GIE 
Bsf			 EECON1, WREN
Movlw		 0x55
Movwf		EECON2 
Movlw		0xAA
Movwf		 EECON2 
Bsf			 EECON1,WR 
Bsf			 INTCON, GIE 
Test
Btfsc		EECON1,WR
Goto		Test
Movlw		A'U'
Bcf			STATUS,RP0
Movwf		EEDATA
Incf		EEADR,f
Bsf			 STATUS, RP0 
Bcf			 INTCON, GIE 
Bsf			 EECON1, WREN
Movlw		 0x55
Movwf		EECON2 
Movlw		0xAA
Movwf		 EECON2 
Bsf			 EECON1,WR 
Bsf			 INTCON, GIE 
Test3
Btfsc		EECON1,WR
Goto		Test3
Movlw		A'S'
Bcf			STATUS,RP0
Movwf		EEDATA
Incf		EEADR,f
Bsf			 STATUS, RP0 
Bcf			 INTCON, GIE 
Bsf			 EECON1, WREN
Movlw		 0x55
Movwf		EECON2 
Movlw		0xAA
Movwf		 EECON2 
Bsf			 EECON1,WR 
Bsf			 INTCON, GIE 
Test1
Btfsc		EECON1,WR
Goto		Test1
Movlw		A'A'
Bcf			STATUS,RP0
Movwf		EEDATA
Incf		EEADR,f
Bsf			 STATUS, RP0 
Bcf			 INTCON, GIE 
Bsf			 EECON1, WREN
Movlw		 0x55
Movwf		EECON2 
Movlw		0xAA
Movwf		 EECON2 
Bsf			 EECON1,WR 
Bsf			 INTCON, GIE 
Test4
Btfsc		EECON1,WR
Goto		Test4
; ----------------------------------------------------------
; Sub Routine Definitions
; ----------------------------------------------------------
;.
;.
;.

	  	 nop			
end				
