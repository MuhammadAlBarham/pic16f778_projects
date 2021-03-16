;**********************************************************
;Muhammad AL-Brham
;0162708
;This program operates a car motor using PWD  
;Start is connected to pin 4 of port B (RB4).
;Output Signal of motor is connected to RC6 
; The program uses a PIC16F877A running at crystal oscillator of frequency 10MHz. 
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
			WTemp		    ; WTemp must be reserved in all banks
			StatusTemp
			PWM_Width
			PWM_Period
			Counter
			BLNKCNT	    	
			CountOuter
			CountInner
	        COUNTER1		;This counter used to time 
			MODE			;It is used to to hold the mode of operation 
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
	bsf			INTCON,GIE		;Enable Global Interrupt
	bsf 		INTCON,PEIE
	bsf			INTCON,RBIE		;Enable RB Port Change Interrupt

	banksel		TRISC
	clrf		TRISC			; All of the PORTC bits are outputs
	movlw		0xF0	
	movwf		TRISB			;Set port B pins (RB0-RB3 outputs, RB4-Rb7 inputs)

	banksel 	ADCON0			; Select register bank 0
	clrf 		TMR2		
	clrf  		PIR1

	movlw 		0x7F 
	movwf 		T2CON

    banksel 	PIE1
	movlw 		0x02
	movwf 		PIE1
 	
    MOVLW 		D'255'
	movwf 		PR2

    banksel     PWM_Width
	clrf		PWM_Width
	clrf		PWM_Period

	banksel 	COUNTER1	
	clrf 		COUNTER1	
	clrf 		MODE       ;clear the MODE register 
	incf 		MODE	   ;increasing the value by one (this mean the first mode of operation(increasing mode))	
	bcf			PIR1,1	   ;Clear the flage of Timer2 
	
;**********************************************************
; Main Routine
	
Main
	sleep                       ;Keep the PIC in sleep mode save power 
	
	movlw 		D'100'			;we have a period timee equal to 100 
								;I use 100 as a vlaue since it is easy to manuplate  
	movwf 		PWM_Period		;initialize the PWM_Period with 100  	
L1	
	bsf			PORTC,RC6		;Set PWM signal to RC6 ( output of motor ) 
	clrf		Counter
L2
	incf		Counter,F
	movf		PWM_Width,w    
	subwf		Counter,w
	btfsc		STATUS,Z
	bcf			PORTC,RC6		;clear PWM signal from RC6( output of motor ) 
	movf		PWM_Period,w
	subwf		Counter,w
	btfsc		STATUS,Z
	goto		L1
	goto		L2


;**********************************************************
; Interrupt Service Routine

INT_SVC
	push

	call	MODE_Select

	pop

	retfie

;**********************************************************
; MODE_Select Routine

MODE_Select
	CALL		TEST             ;This test used to to chech a counter value 
                                 ;I divied the operation of motor for 3 regions 
								 ;First region is increasing to maximum value   (Time =2 s)
								 ;Second region is holding on  maximum value    (Time =4 s)
								 ;Third region is decrementting to minimum value(Time =2 s) 
													
	incf		COUNTER1 		 ;each time increament the counter by 1 
	
	movf 		MODE,0	      	 ;Check the Mode of operation 
 							  	 ;increment mode of operation  (mode 1 )
	sublw	    D'1'
	btfsc		STATUS,Z	
	goto  	    Duty_inc

	movf 		MODE,0	     	 ;hold mode of operation (mode 2)
	sublw	    D'2'
	btfsc		STATUS,Z	
	goto  	    Cont

	movf 		MODE,0			 ;decrement mode of operation  (mode 1 )
	sublw	    D'3'
	btfsc		STATUS,Z	
	goto  	    Duty_dec
	

				
Duty_inc						;each 0.1 s increased the value of PWM_Width by 5 
	movlw	D'5'
	addwf 	PWM_Width,1
	goto	Cont		
Duty_dec
	movlw	D'5'				;each 0.1 s decreased the value of PWM_Width by 5 
	subwf 	PWM_Width,1
	goto	Cont		

Cont
	call	Delay          	   ;This time equal to 100 ms 
	movf	PORTB,w		       ;make change on PORTB 	
	bcf		INTCON,RBIF	       ;Clear the flage of interrupt 
	bcf		PIR1,1		       ;Clear the Flage of TIMER2
finish 
	
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
; This subroutine to check the COUNTER1 
TEST 
								;check the value of COUNTER1 
								;COUNTER1 = 80 means we in the end (end of mode 3 ) 
	movf 	COUNTER1,0			
	sublw 	D'80'
	btfsc	STATUS,Z
	goto	repair1				;repair1 is set the initial values of COUNTER1 AND MODE
	
	movf 	COUNTER1,0
	sublw 	D'60'				;COUNTER1 = 60 means we in the end of second mode 
	btfsc	STATUS,Z
	INCF 	MODE 
	
	movf 	COUNTER1,0			;;COUNTER1 = 20 means we in the end of second mode 
	sublw 	D'20'
	btfsc	STATUS,Z
	incf 	MODE 
	 
	return 

repair1
	clrf 	COUNTER1		;initialize the COUNTER1 by 0 
	movlw 	1
	movwf 	MODE			;Set the first mode 
	goto finish

;*****************************************************************************
	nop 
	nop  	
	end