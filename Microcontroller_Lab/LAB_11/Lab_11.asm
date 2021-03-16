;**********************************************************
; Lab11.asm
;This program operates a car lighting system using 4 pushbuttons 
;Each pushbutton will set a different value that used to pulse width modulate
;pushbuttons are connected to the pins of port B (RB4-RB7).
;light bulb is connected to RC6.
;The program uses a PIC16F877A running at crystal oscillator of frequency 4MHz. 
;**********************************************************

	include	"p16f877A.inc"

;**********************************************************
; Macro definitions

push	macro

	movwf		WTemp		; WTemp must be reserved in all banks
	swapf		STATUS,W	; store in W without affecting status bits
	banksel		StatusTemp	; select StatusTemp bank
	movwf		StatusTemp	; save STATUS
	endm

pop	macro

	banksel		StatusTemp	; point to StatusTemp bank
	swapf		StatusTemp,W	; unswap STATUS nibbles into W	
	movwf		STATUS		; restore STATUS
	swapf		WTemp,F		; unswap W nibbles
	swapf		WTemp,W		; restore W without affecting STATUS
	endm
;**********************************************************
Sec_1		equ	    D'10'	; Number of centiseconds in a second 
CountOuter0	equ	    D'10'
CountInner0	equ	    D'250'
;**********************************************************
; User-defined variables

	cblock		0x20		; bank 0 assignnments
			WTemp		; WTemp must be reserved in all banks
			StatusTemp
			PWM_Width
			PWM_Period
			Counter
			BLNKCNT	    	
			CountOuter
			CountInner
			COUNTER	
	endc

	cblock		0x0A0		; bank 1 assignnments
			WTemp1		; bank 1 WTemp
	endc

	cblock		0x120		; bank 2 assignnments
			WTemp2		; bank 2 WTemp
	endc

	cblock		0x1A0		; bank 3 assignnments
			WTemp3		; bank 3 WTemp
	endc

;**********************************************************
; Start of executable code

	org		0x000
	nop				
	goto		Initial

;**********************************************************
; Interrupt vector

	org		0x0004		
	goto		INT_SVC		; jump to the interrupt service routine

;**********************************************************
; Initial Routine

Initial
	banksel		PORTC
	clrf		PORTC			;Clear PORTC
;	bsf			INTCON,GIE		;Enable Global Interrupt
;	bsf			INTCON,RBIE		;Enable RB Port Change Interrupt

	banksel		TRISC
	clrf		TRISC			; All of the PORTC bits are outputs
	movlw		0xF0	
	movwf		TRISB			;Set port B pins (RB0-RB3 outputs, RB4-Rb7 inputs)
;	bcf		OPTION_REG,7		;Enable PORTB pull-ups 

	banksel 	ADCON0			; Select register bank 0
	clrf		PWM_Width
	clrf		PWM_Period
	movlw 5
	movwf 	COUNTER
	movf 	PORTB,1
	movlw 	00000000
	movwf  	PORTB
	
;**********************************************************
; Main Routine
	
Main
;	sleep

loop_1
 	btfss	PORTB,RB4
 	goto 	loop_1


  	decf COUNTER,1

    call	Duty_Select


	comf		PWM_Period
L1	
	bsf			PORTC,RC6		;Set PWM signal to RC6
	clrf		Counter
L2
	incf		Counter,F
	movf		PWM_Width,w
	subwf		Counter,w
	btfsc		STATUS,Z
	bcf			PORTC,RC6		;clear PWM signal from RC6
	movf		PWM_Period,w
	subwf		Counter,w
	btfsc		STATUS,Z
	goto		L1
	btfss		PORTB,RB4
	goto		L2
	goto 		loop_1

;**********************************************************
; Interrupt Service Routine

INT_SVC
	push

	call	Duty_Select

	pop

	retfie

;**********************************************************
; Duty_Select Routine

Duty_Select

	movf	COUNTER,W	
	sublw	4
	btfsc 	STATUS,Z		
	goto    Duty_25

	movf	COUNTER,W	
	sublw	3
	btfsc 	STATUS,Z		
	goto Duty_50

	movf	COUNTER,W	
	sublw	2
	btfsc 	STATUS,Z		
	goto    Duty_75

	movf	COUNTER,W	
	sublw	1
	btfsc 	STATUS,Z		
	goto    Duty_100
	goto		Cont
	
Duty_25

	movlw	d'64'
	movwf	PWM_Width
	goto	Cont		
Duty_50
    
	movlw	d'128'
	movwf	PWM_Width
	goto	Cont
Duty_75
	
	movlw	d'192'
	movwf	PWM_Width
	goto	Cont
Duty_100
	movlw 5
	movwf COUNTER
	movlw	d'255'
	movwf	PWM_Width
Cont
	call	Delay         ;we use the delay to solve the problem of De_Bouncing
	;movf	PORTB,w
	;bcf		INTCON,RBIF
	clrf 	PWM_Period
	return
;;;;;;; Delay subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This subroutine to get a delay with 100 mSec.
Delay

Sec	movlw	Sec_1
	movwf	BLNKCNT

TenMs
	movlw	CountOuter0
	movwf	CountOuter

DecO	
	movlw	CountInner0
	movwf	CountInner

DecI	
	nop
	decfsz	CountInner, F
	goto	DecI
	decfsz	CountOuter, F
	goto	DecO
	decfsz	BLNKCNT, F
	goto	TenMs	
	Return
;**********************************************************
	end
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	