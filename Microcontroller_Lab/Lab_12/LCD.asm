
;********************************************************************************
; 					Example Code
;********************************************************************************
; Function: 
;	
;
; Connections:
;		Input:
;			Keypad Row 1:	RB0		
;			Keypad Row 2:	RB1	
;			Keypad Row 3:	RB2		
;			Keypad Row 4:	RB3				
;			Keypad Col 1:	RB4	
;			Keypad Col 2:	RB5
;			Keypad Col 3: 	RB6
;			Keypad Col 4: 	RB7
;	LCD Control:
;				RA1: RS	(Register Select)
;				RA3: E	(LCD Enable)
;	LCD Data:
;				PORTD 0-7 to LCD DATA 0-7 for sending commands/characters
;	 Notes:
;	The RW pin (Read/Write) - of the LCD - is connected to RA2
;	The BL pin (Back Light) ? of the LCD ? is connected potentiometer
;		Output:
;			7-Segment A-G: PORTC 0-6 
;			7-Segment Digit Enable 1: Connected To RA0 On Board

__CONFIG _DEBUG_OFF&_CP_OFF&_WRT_HALF&_CPD_OFF&_LVP_OFF&_BODEN_OFF&_PWRTE_OFF&_WDT_OFF&_XT_OSC
;********************************************************************************
#INCLUDE "P16F877A.INC"

CBLOCK	0x20
DELCNTR1		; Used in generating 10 ms delay
DELCNTR2	
KPAD_PAT		; Holds the pattern retrieved from keypad
KPAD_ADD	  	; Holds keypad address to lookup table (generated from 
				; KPAD_PAT to get KPAD_CHAR)
KPAD_CHAR		; Holds the 7-segment representation of the most recent 
				; character pressed on keypad  
ENDC
;********************************************************************************
Zero    	equ	    B'00111111' ; 7-Segment Code for Zero
One      	equ	    B'00000110'	; 7-Segment Code for One
Two     	equ     B'01011011' ; 7-Segment Code for Two
Three	  	equ	    B'01001111' ; 7-Segment Code for Three
Four		equ     B'01100110'	; 7-Segment Code for Four
Five		equ     B'01101101'	; 7-Segment Code for Five
Six     	equ     B'01111101' ; 7-Segment Code for Six
Seven	  	equ	    B'00000111' ; 7-Segment Code for Seven
Eight		equ     B'01111111'	; 7-Segment Code for Eight
Nine		equ     B'01101111'	; 7-Segment Code for Nine
LetterA		equ		B'01110111'	; 7-Segment Code for A
LetterB		equ		B'01111100'	; 7-Segment Code for B
LetterC		equ		B'01011000'	; 7-Segment Code for C
LetterD		equ		B'01011110'	; 7-Segment Code for D
LetterE		equ		B'01111001'	; 7-Segment Code for E
LetterF		equ		B'01110001'	; 7-Segment Code for F
;*************************************************************************** 
; START OF EXECUTABLE CODE	
;*************************************************************************** 
	ORG	0x00
	GOTO	INITIAL
;*************************************************************************** 
; INTERRUPT VECTOR
;*************************************************************************** 
	ORG	0x04		
;	GOTO	KPAD_TO_7SEG
;*************************************************************************** 
INITIAL
		banksel 		TRISB 	
		clrf 			TRISB
		banksel 		PORTB 	
		clrf 			PORTB 				

	goto	Main			;Do it again 

;*************************************************************************** 
; INTERRUPT SERVICE ROUTINE. 
;*************************************************************************** 
; Delay subroutine
; Delay of approx. 10ms which is more than enough for de-bouncing
;*************************************************************************** 
Main
movlw  	b'11111111'
movwf 	PORTB
call 	DELAY
call 	DELAY
call 	DELAY
call 	DELAY
call 	DELAY
call 	DELAY
call 	DELAY
call 	DELAY
call 	DELAY
call 	DELAY
call 	DELAY
call 	DELAY
call 	DELAY
call 	DELAY
call 	DELAY
call 	DELAY
call 	DELAY
call 	DELAY
call 	DELAY	
call 	DELAY
call 	DELAY
call 	DELAY
call 	DELAY
call 	DELAY
call 	DELAY
call 	DELAY
clrf 	PORTB		
goto 	Main


DELAY					 
		MOVLW	0X20		
		MOVWF	DELCNTR1
		CLRF	DELCNTR2
LOOP2
		DECFSZ	DELCNTR2,F
		GOTO	LOOP2
		DECFSZ	DELCNTR1,F
ENDLCD
		GOTO		LOOP2
       	RETURN
		END
;*************************************************************************** 