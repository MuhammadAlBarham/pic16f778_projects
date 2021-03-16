;**********************************************************
; This program control a bottle labeling and packing machine.
; Photocell sensor is connected into RB0
; 7-Segments is connected to PORTB (We connect RB1 to a, RB2 to b ???.And RB7 to g)
; Digits selection of bottles number 7-Segments is connected to RA0
; Digits selection of cartoon number 7-Segments is connected to RA1
; Conveyer belt motor is connected to RA2
; Label actuator is connected to RA3
; START pushbutton is connected to RA4
; The program uses a PIC16F84A running at crystal oscillator of frequency 4MHz. 
;**********************************************************
 include "p16f84A.inc"
;**********************************************************
; Macro definitions

push	macro

	movwf		WTemp		    ; WTemp must be reserved in all banks
	swapf		STATUS,W		; store in W without affecting status bits
	banksel	    StatusTemp		; select StatusTemp bank
	movwf		StatusTemp		; save STATUS
	endm

pop	macro

	banksel	    StatusTemp		; point to StatusTemp bank
	swapf		StatusTemp,W		; unswap STATUS nibbles into W	
	movwf		STATUS		; restore STATUS
	swapf		WTemp,F		; unswap W nibbles
	swapf		WTemp,W		; restore W without affecting STATUS
	endm
;**********************************************************
; User-defined variables
	cblock		0x0C		; bank 0 assignments
	WTemp	
	StatusTemp
	photocell                	;Add all variables here.
    start
  	Digit_select_bottle 
    Digit_select_cartoon
 ;	conveyor_belt_motor
  ;  label_actuator  
;--------------------
    counter1             		
	counter2
    bottle_num
    cartoon_num
	endc
;**********************************************************
; Start of executable code
	org	0x00		
	nop
	goto    	Main		
	org	0x04	        	;Reset vector
	goto		INT_SVC
	;;;;;;; Main program ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Main
	call	Initial		;Initialize everything
MainLoop
	call	Bottle_Number		;Check if the number of bottles reaches to nine
	call    Cartoon_Number		;Check if the number of packing bottles reaches to nine.
	goto	MainLoop			;Do it again
;;;;;;;	Initial subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This subroutine performs all initializations of variables and registers.
Initial	
;First initialize the PORTA & PORTB 
bsf STATUS,RP0         ;Go to bank 1 
;Initilize the PORTA 
movlw b'00010000'         ;"input/output/output/output/output"
movwf TRISA      	   ;Initialization  of the PORTA 
;Initilize the PORTB
movlw b'00000001'      ;"output/output/output/output/output/output/output/Input"
movwf  TRISB           ;Initialization  of the PORTB 
bcf STATUS,RP0         ;Goto bank 0 
;Initilaze the PORTS with Initial Values 
movlw b'01111110'  ;  " g  f e d c b a 0 "    ;Initilize the PORTB with value 0 (Show Num on 7-seg)
movwf PORTB  
movlw b'00000101' 
movwf PORTA
bsf INTCON,GIE        ;Enable the global interrupt enable 
bsf INTCON,INTE       ;Enable the  External Interrupt
;-----------------
clrf bottle_num 
clrf cartoon_num
	Return
;;;;;;; Bottle_Number subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This subroutine Test if the number of bottles reaches to nine. 
Bottle_Number
movlw D'9'
subwf bottle_num,W      ; The number of the bottle 
btfss STATUS,Z          ; Check if the number of the bottle reach 9 or not ? 
goto Bottle_Number
Return 
;Return
;**********************************************************
;;;;;;; Cartoon_Number subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This subroutine Test if the number of packing bottles reaches to nine.
Cartoon_Number 
incf	  cartoon_num
clrf	  bottle_num	
bcf PORTA,RA2         ;Stop the conveyor belt
	call Delay            ;These 3 statement of call delay  
	call Delay            ;Take approximetaly 3.6 s 
	call Delay  
	movlw D'2'
	subwf cartoon_num,W 
	btfsc STATUS,Z 
	goto  Check_start 
    End_the_code 
	
    Return 
;**********************************************************
;;;;;;; Delay subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This subroutine to get a delay with 1.2 Sec.
Delay                   ; This code take delay equal to (1.200755)*10^6 
movlw 250
movwf counter1           
repeat 
call sub_delay 
call sub_delay 
call sub_delay  
call sub_delay 
call sub_delay 
call sub_delay 
decfsz counter1,f
goto repeat 
	 Return
sub_delay                ;This sub_delay has 800 machine cycle 
movlw 159 
movwf counter2
repeat2
nop 
nop 
decfsz counter2,1 
goto repeat2 
     Return 
;**********************************************************
; Bottle_Labeling
Bottle_Labeling
	bcf	    INTCON, INTF	;Clear the External interrupt flag
;	write the code here
    incf   bottle_num
    call   Look_Up
    movwf  PORTB             ;Move the Number to Show it in 7-seg.
    bsf    PORTA,4 
    call   Delay             ;The value of the Delay equal to 1.2 Second 
    bcf    PORTA,4 
	goto   POLL    	 ;Check for another interrupt
;**********************************************************
INT_SVC 
push
POLL 
	btfsc		INTCON, INTF	    ; Check for an External Interrupt
	goto		Bottle_Labeling
;	btfsc	...		        		; Check for another interrupt
;	call	...
;	btfsc	...		        		; Check for another interrupt
;	call	...
	pop
	retfie

;**********************************************************
; ----------------------------------------------------------
; Sub Routine Definitions
; ----------------------------------------------------------
    Look_Up

Movf        bottle_num,W
Addwf       PCL,f
Retlw       B'01111110'  ;NUMBER 0
Retlw       B'00001100'  ;NUMBER 1
Retlw       B'10110110'	 ;NUMBER 2
Retlw       B'10011110'  ;NUMBER 3 
Retlw       B'11001100'  ;NUMBER 4
Retlw       B'11011010'  ;NUMBER 5
Retlw       B'11111010'  ;NUMBER 6
Retlw       B'00001110'  ;NUMBER 7
Retlw       B'11111110'  ;NUMBER 8
Retlw       B'11100110'  ;NUMBER 9
;***********************************************************

;***********************************************************
Check_start
bcf PORTA,RA0 
bsf PORTA,RA1
movlw D'9'
call Look_Up 
check_start1
btfss PORTA,RA4       				 ;Check if the Start Button begin or not 
goto check_start1
movlw b'00000000'
movwf PORTB
;bsf PORTA,RA0
;bcf PORTA,RA1
;bsf PORTA,RA2 
;bcf PORTA,RA3
;bcf PORTA,RA4
movlw b'00000101' 
movwf PORTA
bsf INTCON,GIE 
bsf INTCON,INTE
clrf cartoon_num
goto  End_the_code
	End