;**********************************************************
; This program Serial with A/D protocol based transmission.
;**********************************************************

	include "p16f877A.inc"

__CONFIG   	_CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_OFF & _XT_OSC
;**********************************************************
; User-defined variables

	cblock	0x20
		WTemp			; Must be reserved in all banks
		StatusTemp
		Pressure_Reading
		Difference
		Pressure_Result
		Temperature_Reading
		Counter	
		Time	
	endc

	cblock	0x0A0			; bank 1 assignnments
		WTemp1			; bank 1 WTemp
	endc

	cblock	0x120			; bank 2 assignnments
		WTemp2			; bank 2 WTemp
	endc

	cblock	0x1A0			; bank 3 assignnments
		WTemp3			; bank 3 WTemp
	endc
;**********************************************************
; Macro Assignments

push	macro
	movwf	WTemp		;WTemp must be reserved in all banks
	swapf	STATUS,W	;store in W without affecting status bits
	banksel	StatusTemp	;select StatusTemp bank
	movwf	StatusTemp	;save STATUS
	endm

pop	macro
	banksel	StatusTemp	;point to StatusTemp bank
	swapf	StatusTemp,W	;unswap STATUS nybbles into W	
	movwf	STATUS		;restore STATUS (which points to where W was stored)
	swapf	WTemp,F		;unswap W nybbles
	swapf	WTemp,W		;restore W without affecting STATUS
	endm

;**********************************************************
; Start of executable code

	org	0x00		; Reset vector
	nop
	goto	Main

;**********************************************************
; Interrupt vector

	org	0x04		; interrupt vector
	goto	IntService
;**********************************************************
; Main program 

Main
	call	Initial		; Initialize everything
Mainloop
	call	Pressure_Conversion
	call	Pressure_Test
	call	Temperature_Conversion
	goto	Mainloop	; Do it again

;**********************************************************
; Initial Routine

Initial	
	movlw	D'25'		; This sets the baud rate to 9600
	banksel	SPBRG		; assuming BRGH=1 and Fosc=4.000 MHz
	movwf	SPBRG       ; This is the value of X 

	banksel	RCSTA		; Enable the serial port
	bsf		RCSTA, SPEN

	banksel	TXSTA
	bcf		TXSTA, SYNC	; Set up the port for asynchronous operation
	bsf		TXSTA, TXEN	; Transmit enabled
	bsf		TXSTA, BRGH	; High baud rate
	bcf		TXSTA,TX9	; Disable 9-bit transmit

	banksel	PIE1		; Enable the Timer2 interrupt
	bsf		PIE1, TMR2IE
	bcf		TRISC,RC6	; Set RC6/TX to output Send Pin
	bsf		TRISA,RA0	; Set RA0 to input	
	bsf		TRISA,RA1	; Set RA1 to input

	banksel	INTCON		; Enable global and peripheral interrupts
	bsf		INTCON, GIE
	bsf		INTCON, PEIE

	movlw	D'194'		; Set up the Timer2 Period register to get 50ms 
	banksel	PR2
	movwf	PR2
	movlw	B'01111110'	; Set up Timer2 postscale=1:16, prescaler=16
	banksel	T2CON
	movwf	T2CON

	banksel		ADCON1
	movlw		B'00000100'	; A/D data left justified, 3 analog channels AN0, AN1 and AN3
							; VDD and VSS references
	banksel 	ADCON0		; Select register bank 0
	movlw		0x02
	movwf		Counter

	return
 
;**********************************************************
	Pressure_Conversion
	banksel	ADCON0
	movlw	B'01000001'	; Fosc/8, A/D Channel , A/D enabled
	movwf	ADCON0
	call	Delay
	bsf		ADCON0,GO	; Start A/D conversion
Wait
	btfsc	ADCON0,GO	; Wait for conversion to complete
	goto	Wait
	movf	ADRESH, W	; Get A/D result
	movwf	Pressure_Reading
	return
;**********************************************************
	Pressure_Test

	decfsz	Counter,f			;Send first reading regardless of the 
	goto	Send				;value of the change in pressure
	movf	Pressure_Result,w
	subwf	Pressure_Reading,w	;Pressure_Reading - Pressure_Result
	movwf	Difference
	btfss  	STATUS,C	
	call	repair
	sublw	d'25'		; 25 - Difference
	btfsc	STATUS,C
	goto	Continue
Send
	movf	ADRESH, W			; Get A/D result
	movwf	Pressure_Result
	call	Pressure_Transmision
Continue
	movlw	0x01
	movwf	Counter

	return

;**********************************************************
	Pressure_Transmision

	banksel	TXREG
	movlw	0x50
	movwf	TXREG				; Send a "P" out the serial port
	banksel	TXSTA
L1	btfss	TXSTA,TRMT
	goto	L1
	banksel	TXREG
	movf	Pressure_Result,w
	movwf	TXREG				; Send a pressure reading out the serial port
	banksel	TXSTA
L10	btfss	TXSTA,TRMT
	goto	L10
	banksel 	ADCON0		; Select register bank 0
	return
;*********************************************************
Temperature_Conversion
	banksel	ADCON0
	movlw	B'01001001'		; Fosc/8, A/D Channel 1, A/D enabled
	movwf	ADCON0
	call	Delay
	bsf		ADCON0,GO		; Start A/D conversion
Wait1
	btfsc	ADCON0,GO		; Wait for conversion to complete
	goto	Wait1
	movf	ADRESH, W		; Get A/D result
	movwf	Temperature_Reading

	return
;**********************************************************    
; Interrupt Service Routine
; This routine is called whenever we get an interrupt.
IntService
	push

;	btfsc	PIR1, TMR2IF	; Check for a Timer2 interrupt

	banksel	TXREG
	movlw	0x54
	movwf	TXREG				; Send a "T" out the serial port
	banksel	TXSTA
L2	btfss	TXSTA,TRMT
	goto	L2
	banksel	TXREG
	movf	Temperature_Reading,w
	movwf	TXREG		; Send temperature reading out the serial port
	banksel	TXSTA
L20	btfss	TXSTA,TRMT
	goto	L20
	banksel	PIR1
	bcf		PIR1, TMR2IF	; Clear the Timer2 interrupt flag

	pop

	retfie
;********************************************************** 
Delay
	movlw	0x0F
	movwf	Time
X1	decfsz	Time,f
	goto	X1
	return
;**********************************************************

repair 
comf 	Difference,1
incf	Difference,0
 return 
	end