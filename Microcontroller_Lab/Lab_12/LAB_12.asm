
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
; Notes:
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
;tempChar
;charCount
lsd				;lsd and msd are used in delay loop calculation
msd	 
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
		BANKSEL TRISA		
		CLRF    TRISA
		CLRF	TRISD
		CLRF	TRISC	
		MOVLW 	B'11110000'				; PORTB initially row bits as output, column 
										; as input
		MOVWF 	TRISB		   	
		BCF		OPTION_REG, NOT_RBPU    ; Turn on all internal pull-ups of PORTB

		BANKSEL ADCON1 
		MOVLW   0X06                                                   
 		MOVWF   ADCON1               	;set PORTA as general Digital I/O PORT   
     
		BANKSEL PORTB
		CLRF 	PORTB					
		movlw 	Zero					; Send Zero to output
		movwf	PORTC
		BSF		PORTA,RA0		
		BCF		INTCON, RBIF			; Initialize and enable port-on-change
		BSF		INTCON, RBIE			; interrupt
		BSF		INTCON, GIE	
;Initialize LCD 
		Movlw	0x38		;8-bit mode, 2-line display, 5x7 dot format
		Call	send_cmd	
		Movlw	0x0e		;Display on, Cursor Underline on, Blink off
		Call	send_cmd
		Movlw	0x02		;Display and cursor home
		Call	send_cmd
		Movlw	0x01		;clear display
		Call	send_cmd
		call	DrawStick1
 	    Call    DrawStick2
		Movlw	0x01		;clear display
		Call	send_cmd
;**********************************************************************************	
call delay
Movlw	a'A'
   Call         send_char

Main
   

	movf	KPAD_CHAR,w
	sublw	One
	btfsc	STATUS,Z
	call    Page1
	movf	KPAD_CHAR,w
	sublw	Two
	btfsc	STATUS,Z
	call    Page2
	movf	KPAD_CHAR,w
	sublw	Three
	btfsc	STATUS,Z
	call    Page3


	goto	Main			;Do it again
;**********************************************************************************
DrawStick1				; Setting the CGRAM address at which we draw the stick man
		Movlw	0x40		; Here it is address 0x00
		Call	send_cmd		
		Movlw	0X0E		; Sending data that implements the Stick man
		Call	send_char		
		Movlw	0X11			
		Call	send_char				
        Movlw	0X0E			
	    Call	send_char				
        Movlw	0X04					
        Call	send_char				
        Movlw	0X1F					
        Call	send_char				
        Movlw	0X04					
        Call	send_char
		Movlw	0X0A
		Call	send_char
		Movlw	0X11
		Call	send_char
		Return		

;**********************************************************************************
DrawStick2				; Setting the CGRAM address at which we draw the stick man
		Movlw	0x48		; Here it is address 0x01
		Call	send_cmd		
		Movlw	0X0E		; Sending data that implements the Stick man
		Call	send_char		
		Movlw	0X0A			
		Call	send_char				
        Movlw	0X04			
	    Call	send_char				
        Movlw	0X15					
        Call	send_char				
        Movlw	0X0E					
        Call	send_char				
        Movlw	0X04					
        Call	send_char
		Movlw	0X0A
		Call	send_char
		Movlw	0X0A
		Call	send_char
		Return	
;**********************************************************************************
Page1
 	    Movlw	0x88		;Set display address
		Call	send_cmd
		Movlw	0x00
		Call    send_char
		Movlw	0x88		;Set display address
		Call	send_cmd 
		call	delay
		call	delay
		Movlw   0x01
     	Call    send_char     
	return
Page2

		Movlw	0x01		;clear display
		Call	send_cmd
Movlw	0x02		;Display and cursor home
		Call	send_cmd
return
Page3
         
		Movlw	0x01
		Call    send_char
		call	delay
		call	delay
		Movlw   0x00
     	Call    send_char     
	return

;**********************************************************************************
send_cmd
		movwf	PORTD		; Refer to table 1 on Page 5 for review of this subroutine	
		bcf		PORTA,RA1   ;                                                                         
		bsf		PORTA,RA3	
		nop				
		bcf		PORTA,RA3

		bcf		PORTA,RA2
		call	delay			
		return
;**********************************************************************************
send_char
		movwf	PORTD		; Refer to table 1 on Page 5 for review of this subroutine	
		bsf		PORTA,RA1	 
		bsf		PORTA,RA3		
		nop
		bcf		PORTA,RA3
		bcf		PORTA,RA2
		call	delay
		return
;**********************************************************************************
delay	                                                                                
		movlw	0x80			
		movwf	msd
		clrf	lsd
loop2
		decfsz	lsd,f
		goto	loop2
		decfsz	msd,f
endLcd
		goto	loop2
		return

;*************************************************************************** 
; INTERRUPT SERVICE ROUTINE. 
;*************************************************************************** 


; Delay subroutine
; Delay of approx. 10ms which is more than enough for de-bouncing
;*************************************************************************** 
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