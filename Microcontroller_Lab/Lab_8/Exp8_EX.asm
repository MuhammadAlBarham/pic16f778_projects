;**********************************************************
; This program used to find the frequency of shaft encoder using Timer0 and Timer1
; Show the frequency on bargraph LED connected to PORT D 
; The signal of shaft encoder is connected to RA4 as a clock to Timer0 
; 7-Segments is connected to PORTB (We connect RB0 to a, RB1 to b ???.And RB6 to g)to show the numbers on 7-seg  
; The program uses a PIC16F877A running at crystal oscillator of frequency 4MHz. 
;**********************************************************
 include "p16f877A.inc"
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
	swapf		StatusTemp,W; unswap STATUS nibbles into W	
	movwf		STATUS		; restore STATUS
	swapf		WTemp,F		; unswap W nibbles
	swapf		WTemp,W		; restore W without affecting STATUS
	endm

;**********************************************************
; User-defined variables
	
	cblock		0x20		; bank 0 assignnments
			WTemp	    	; WTemp must be reserved in all banks
			StatusTemp
			Timer0Counts
            counter 
			
	endc

	cblock		0x0A0		; bank 1 assignnments
			WTemp1	    	; bank 1 WTemp
	endc

	cblock		0x120		; bank 2 assignnments
			WTemp2	    	; bank 2 WTemp
	endc

	cblock		0x1A0		; bank 3 assignnments
			WTemp3	    	; bank 3 WTemp
	endc

;**********************************************************
; Start of executable code
	org	0x00		;Reset vector
	nop
	goto    	Main		
	org	0x04	        
	goto		INT_SVC
	;;;;;;; Main program ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Main
	call	Initial				;Initialize everything
MainLoop
	call	Range_Test
	goto	MainLoop			;Do it again
;;;;;;;	Initial subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This subroutine performs all initializations of variables and registers.
Initial	
	banksel	TRISA				;Select bank1
	clrf	TRISD				;set all bits of port D to output
	movlw	0x07
	movwf	ADCON1				;set port A to digital I/O pins 
	movlw	0xFF				
	movwf	TRISA				;set port A to inputs
	movlw	0x28
	movwf	OPTION_REG			;TMR0 Clock Source Transition on RA4/T0CKI pin
								;Incr yyhmement on low-to-high transition on RA4/T0CKI pin
								;Prescaler is assigned to the WDT module,Prescaler WDT (1:1)
	bsf		INTCON,GIE			;Enable Global Interrupt 
	bsf		INTCON,PEIE			;Enable peripheral interrupts
	bsf		PIE1,TMR1IE         ;Enable Timer1
	banksel	PORTA
	movlw	0xDF				;..
	movwf	TMR1L				;..	
	movlw	0x0B				;..
	movwf	TMR1H				;initialize TMR1 with 3039 counts to get interrupt every 0.5 Sec.
	movlw	0x30
	movwf	T1CON				;TMR1 Prescale (1:8),TMR1 Oscillator is shut-off
								;Timer1 Clock Source = Internal clock (FOSC/4)
	bsf		T1CON,TMR1ON		;Enables Timer1
	clrf	PORTD				;initialize all LEDs OFF
	clrf	TMR0				;reset TMR0
	clrf	Timer0Counts
	clrf 	counter 
	Return
;;;;;;;	Range_Test subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This subroutine performs test the range of counts and show them on the LEDs.
Range_Test
	movf	Timer0Counts,w
	btfsc	STATUS,Z
	goto	No_Freq
                                ;If the Carry equal to 1 the value will be higher 
                                ;Else the value will be smaller 
	sublw	D'10'				;Freq less than (10)*2=20Hz,0<Freq<20
	btfsc	STATUS,C
	goto	One
	movf	Timer0Counts,w
	sublw	D'25'				;Freq less than (25)*2=50Hz,20<Freq<50
	btfsc	STATUS,C
	goto	Two
	movf	Timer0Counts,w
	sublw	D'40'				;Freq less than (40)*2=80Hz,50<Freq<80
	btfsc	STATUS,C
	goto	Three
	movf	Timer0Counts,w
	sublw	D'55'				;Freq less than (55)*2=110Hz,80<Freq<110
	btfsc	STATUS,C
	goto	Four
	movf	Timer0Counts,w
	sublw	D'70'				;Freq less than (70)*2=140Hz,110<Freq<140
	btfsc	STATUS,C
	goto	Five
	goto	Six					;Freq greater than 140Hz/
One
	movlw	0x01
	movwf	PORTD
	goto	Finish
Two
	movlw	0x03
	movwf	PORTD
	goto	Finish
Three
	movlw	0x07
	movwf	PORTD
	goto	Finish
Four
	movlw	0x0F
	movwf	PORTD
	goto	Finish
Five
	movlw	0x1F
	movwf	PORTD
	goto	Finish
Six
	movlw	0x3F
	movwf	PORTD
	goto	Finish
No_Freq
	clrf	PORTD
Finish
	Return
;**********************************************************
; TIMER1 RE-Initialize and reset
T1
	movlw	0xDD				;..
	movwf	TMR1L				;..	
	movlw	0x0B				;..
	movwf	TMR1H				;initialize TMR1 with 3037 counts to get interrupt every 0.5 Sec.
	bcf		PIR1,TMR1IF
	incf  	counter,1 
	goto	POLL    	        ;Check for another interrupt
;**********************************************************
INT_SVC
push
POLL
	btfsc	PIR1,TMR1IF			; Check for an TMR1 Interrupt (This inerrupt means that take value every 0.5 second )
	goto	T1
	movf 	counter,0	
	sublw 	D'2'	
	btfss	STATUS,Z
	goto  	finish
	
	movf	TMR0,w              ;Take the value of the frequence of the Shaft Encoder 
	movwf	Timer0Counts        ;Save this value in the Timer0Counter 
	clrf	TMR0                ;Clear the Timer to get another value of frequency 
	clrf    counter 	
	
	finish 
	bsf		T1CON,TMR1ON        ;Make Timer1 to be On 
	pop
	retfie

;**********************************************************
	End