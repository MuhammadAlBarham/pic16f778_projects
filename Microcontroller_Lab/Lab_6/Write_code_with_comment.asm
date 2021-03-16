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
;This code have been repier by "Hunter98" 
;Muhammad Al-Brham (Don't Leave Your Dream) 
Main	   
Movlw       0xFF        		 ;Move the value of the Adress to w-Reg
Movwf       EEADR        		 ;Move the Adress to be written inside it 
Movlw		A'M'        		 ;Move the character to W-Reg
call Repeat_code
Movlw		A'U'
call Repeat_code
Movlw		A'S'
call Repeat_code
Movlw		A'A'
call Repeat_code
goto finish
; ----------------------------------------------------------
; Sub Routine Definitions
; ----------------------------------------------------------
Repeat_Code 
Bcf			STATUS,RP0   		 ;Go to bank 0 
Movwf		EEDATA               ;Move the character 'M' to EEDATA
Incf		EEADR,f              ;Increment Adress by 1 
Bsf			STATUS, RP0          ;Go to bank 1
Bcf			INTCON, GIE          ;Disable all INTS
Bsf			EECON1, WREN         ;Enble to write
;------------------------------------------------------
;This code is requiered from datasheet   
Movlw		0x55                 
Movwf		EECON2 
Movlw		0xAA
Movwf		EECON2 
Bsf			EECON1,WR 
Bsf			INTCON, GIE 
;------------------------------------------------------
;This code to test if the Write process end or not 
Test 
Btfsc		EECON1,WR   ;If the WR=0 ,this mean the Write process end !!
Goto		Test
return
 
finish

nop			
end				
