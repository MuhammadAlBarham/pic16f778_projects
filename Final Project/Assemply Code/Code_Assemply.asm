;**********************************************************
;This Code for GLCD  
;**********************************************************
  include "p16f877A.inc"

__CONFIG _DEBUG_OFF&_CP_OFF&_WRT_HALF&_CPD_OFF&_LVP_OFF&_BODEN_OFF&_PWRTE_OFF&_WDT_OFF&_XT_OSC
;**********************************************************
; User-defined variables

CBLOCK	0x20	 
adress_x		; the adress of the x-axis 
adress_y		; the adress of the yaxis 
HD				;the high data 8 bit 
LD				;;the low data 8 bit
Time			; used in delay 
ENDC
;**********************************************************
; Macro Assignments
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
MainLoop
	bcf 	PORTB,0   ;reset the GLLCD (SET LOW = 0) 
	call	delay     ; delay 
	bsf		PORTB,0	  ;reset the GLLCD (SET HIGH=1 )
	call	delay		
	while_loop
	call	Initial_2
	CALL 	start_1
	call	delay
	goto	while_loop


;**********************************************************
; Initial Routine
Initial		
   clrf         Time		;clear the time register 
   banksel 		TRISD		;choose the TRIS to be output (data output) 
   clrf 		TRISD 		;clear the TRISD register 

   banksel 		PORTD 		
   CLRF 		PORTD 

   banksel 		TRISB
   MOVLW		0XC0
   MOVWF 		TRISB

   BANKSEL      PORTB 
   CLRF 	    PORTB 

	banksel 	TRISC
   MOVLW		0X01
   MOVWF 		TRISC

   BANKSEL      PORTC
   CLRF 	    PORTC

   bcf 	        PORTB,RB0
   BANKSEL 	    INTCON
   bCf INTCON,GIE
		
	return
;**********************************************************
; Interrupt Service Routine
; This routine is called whenever we get an interrupt.

IntService
	push

	pop
	
;**********************************************************
Send_cmd 
		movwf 		PORTD		; send the data command 
		bcf			PORTB,RB1   ; Rs=0 select command register 
		
		bsf 		PORTB,RB3  	; set the enable 
		nop 
		bcf 		PORTB,RB3  	; clear the enable 
		
		bcf 		PORTB,RB2
		call		delay
		
		return  
;-------------------------------------------------------------------
Send_char
		movwf 		PORTD		; send the data command 
		bsf			PORTB,RB1   ; Rs=1 select data register 
		
		bsf 		PORTB,RB3  	; set the enable 
		nop 
		bcf 		PORTB,RB3  	; clear the enable 
		
		bcf 		PORTB,RB2	;write the data to the GLCD 
		call	    delay
	
		return  
;--------------------------------------
delay								;Delay by 500 micro 
	movlw	0x9F
	movwf	Time
X1	decfsz	Time,f
	goto	X1
	return
;-----------------------------------------------------------------
Initial_2  					 ;Graphic display Mode

	movlw 	0x30             ; 8-bit mode/ basic=0  (function set)  
	call  	Send_cmd
	movlw 	0x01             ;Display Clear
	call  	Send_cmd
	movlw 	0x36	         ;Extended Function Set:RE=1: extended instruction set
	call  	Send_cmd	
	movlw 	0x3E		     ;EXFUNCTION(DL=8BITS,RE=1,G=1)
	call  	Send_cmd
return
;-----------------------------------------------------------------
Send
	incf 	adress_y,1
	movf	adress_y,0
	call	Send_cmd
	movf	adress_x,0
	call	Send_cmd
	movf 	HD,0
	call	Send_char
	movf	LD,0
	call	Send_char 
return 
;-----------------------------------------------------------------------------------------------
Send_zero
	incf 	adress_y,1
	movf	adress_y,0
	call	Send_cmd
	movf	adress_x,0
	call	Send_cmd
	movlw	0x00
	call	Send_char
	movlw	0x00
	call	Send_char 
return 
;--------------------------------------------------------------------------------------------------
 	Set_address
	movlw	0x7F
	movwf 	adress_y
	incf 	adress_x,1
RETURN 

;--------------------------------------------------------------------------------------------------
ZERO
call 	Send_zero

;2	
call 	Send_zero       

;3
call 	Send_zero
;4
call 	Send_zero
;5
call 	Send_zero
;6
call 	Send_zero
;7
call 	Send_zero
;8
call 	Send_zero
;9
call 	Send_zero
;10
call 	Send_zero
;11
call 	Send_zero
;12
call 	Send_zero
;13
call 	Send_zero
;14
call 	Send_zero
;15
call 	Send_zero
;16
call 	Send_zero
;17
call 	Send_zero
;18
call 	Send_zero
;19
call 	Send_zero
;20
call 	Send_zero
;21
call 	Send_zero
;22
call 	Send_zero
;23
call 	Send_zero
;24
call 	Send_zero
;25
call 	Send_zero
;26
call 	Send_zero
;27
call 	Send_zero
;28
call 	Send_zero
;29
call 	Send_zero
;30
call 	Send_zero
;31
call 	Send_zero
;32
call 	Send_zero
	return 
;--------------------------------------------------------------------------------------------------
start_1
	btfss	PORTB,7
	goto 	switch_0xx
	goto 	switch_1xx

switch_0xx
	btfss	PORTB,6
	goto 	switch_00x
	goto 	switch_01x

switch_00x
	btfss	PORTC,0
	goto 	switch_000
	goto 	switch_001

switch_01x
	btfss	PORTC,0
	goto 	switch_010
	goto 	switch_011
;************************************************************
switch_1xx
	btfss	PORTB,6
	goto 	switch_10x
	goto 	switch_11x

switch_10x
	btfss	PORTC,0
	goto 	switch_100
	goto 	switch_101


switch_11x
	btfss	PORTC,0
	goto 	switch_110
	goto 	switch_111
;--------------------------------------------------------------
switch_000
CALL	MUHAMMD_A
goto start

switch_001
CALL	AHMAD_T
;CALL	MUHAMMD_A
goto start

switch_010
 CALL	AHMAD_G
;CALL	MUHAMMD_A
goto start



switch_011
bcf 	PCLATH,4
BsF		PCLATH,3
CALL	SARA_F
;CALL	MUHAMMD_A
bcf 	PCLATH,4
BcF		PCLATH,3
goto start



switch_100
bsf 	PCLATH,4
BcF		PCLATH,3
CALL	LOVE_YOU_AHMAD
;CALL	MUHAMMD_A
bcf 	PCLATH,4
BcF		PCLATH,3

goto start



switch_101
;bSf 	PCLATH,4
;BCF		PCLATH,3
;CALL	SARA_F 
CALL	MUHAMMD_A

goto start



switch_110
;bSf 	PCLATH,4
;BCF		PCLATH,3
;CALL	NOOR_E
CALL	MUHAMMD_A

goto start



switch_111
;bSf 	PCLATH,4
;BSF		PCLATH,3
;CALL	LOVE_YOU_AHMAD
CALL	MUHAMMD_A

goto start

start
RETURN 
;---------------------------------------------------------

MUHAMMD_A
;This column 1   
	movlw	0x7F
	movwf 	adress_y
	movlw	0x80
	movwf	adress_x
;1	
	call 	Send_zero

;2	
	call 	Send_zero

;3
	call 	Send_zero
;4
	call 	Send_zero
;5
	call 	Send_zero
;6
	call 	Send_zero
;7
	call 	Send_zero
;8
	call 	Send_zero
;9
	call 	Send_zero
;10
	call 	Send_zero
;11
	call 	Send_zero
;12
    call 	Send_zero
;13
	call 	Send_zero
;14
	call 	Send_zero
;15
	call 	Send_zero
;16

    movlw	0x00
	movwf 	HD
	movlw 	0x03
	movwf 	LD
	call	Send
;17
	movlw	0x00
	movwf 	HD
	movlw 	0x07
	movwf 	LD
	call	Send
;18
	movlw	0x00
	movwf 	HD
	movlw 	0x07
	movwf 	LD
	call	Send
;19
	movlw	0x00
	movwf 	HD
	movlw 	0x07
	movwf 	LD
	call	Send
;20
	movlw	0x00
	movwf 	HD
	movlw 	0x07
	movwf 	LD
	call	Send
;21
	movlw	0x00
	movwf 	HD
	movlw 	0x03
	movwf 	LD
	call	Send
;22
	movlw	0x00
	movwf 	HD
	movlw 	0x03
	movwf 	LD
	call	Send
;23
	movlw	0x00
	movwf 	HD
	movlw 	0x03
	movwf 	LD
	call	Send
;24
	movlw	0x00
	movwf 	HD
	movlw 	0x03
	movwf 	LD
	call	Send
;25
	call 	Send_zero
;26
	call 	Send_zero
;27
	call 	Send_zero
;28
	call 	Send_zero
;29
	call 	Send_zero
;30
	call 	Send_zero
;31
	call 	Send_zero
;32
	call 	Send_zero
	
    	call      	Set_address

;New_Column    ---2---


;1	
	call 	Send_zero
;2	
	call 	Send_zero

;3
	call 	Send_zero
;4
	call 	Send_zero
;5
	call 	Send_zero
;6
	call 	Send_zero
;7
	call 	Send_zero
;8
	call 	Send_zero
;9
	call 	Send_zero
;10
	call 	Send_zero
;11
	call 	Send_zero
;12
	call 	Send_zero
;13
	call 	Send_zero
;14
	call 	Send_zero
;15
	call 	Send_zero
;16
	movlw	0x80
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send

;17
	movlw	0x80
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send

;18
	movlw	0x80
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send

;19
	movlw	0xC0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send


;20
	movlw	0xC0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;21
	movlw	0xC0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;22
	movlw	0xC0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;23
	movlw	0xE0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;24
	movlw	0xE0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;25
	movlw	0xE0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;26
	movlw	0xE0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;27
	movlw	0xE0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;28
	movlw	0xC0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;29
    	movlw	0xC0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;30
	movlw	0xC0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;31
	
	call 	Send_zero
;32
	
	call 	Send_zero
	
	
	call      	Set_address

;New_Column    ---3---

	call	ZERO
	call    Set_address

;New_Column    ---4--

	call	ZERO

	call      	Set_address
;New_Column    ---5--


;1	
	call 	Send_zero

;2
	call 	Send_zero

;3
	call 	Send_zero
;4
	call 	Send_zero
;5
	call 	Send_zero
;6
	call 	Send_zero
;7
	call 	Send_zero
;8
	call 	Send_zero
;9
	call 	Send_zero
;10
	call 	Send_zero
;11
	call 	Send_zero
;12
	movlw	0x00
	movwf 	HD
	movlw 	0x0F
	movwf 	LD
	call	Send
;13
	movlw	0x00
	movwf 	HD
	movlw 	0x3F
	movwf 	LD
	call	Send
;14
	movlw	0x00
	movwf 	HD
	movlw 	0x30
	movwf 	LD
	call	Send
;15
	movlw	0x00
	movwf 	HD
	movlw 	0x30
	movwf 	LD
	call	Send
;16
	movlw	0x00
	movwf 	HD
	movlw 	0x30
	movwf 	LD
	call	Send
;17
	movlw	0x00
	movwf 	HD
	movlw 	0x18
	movwf 	LD
	call	Send
;18
	movlw	0x00
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send
;19
	movlw	0x00
	movwf 	HD
	movlw 	0x0C
	movwf 	LD
	call	Send
;20
	movlw	0x00
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send
;21
	movlw	0x00
	movwf 	HD
	movlw 	0x0C
	movwf 	LD
	call	Send
;22
	movlw	0x00
	movwf 	HD
	movlw 	0x06
	movwf 	LD
	call	Send
;23
	movlw	0x00
	movwf 	HD
	movlw 	0x06
	movwf 	LD
	call	Send
;24
	movlw	0x00
	movwf 	HD
	movlw 	0x07
	movwf 	LD
	call	Send
;25
	movlw	0x00
	movwf 	HD
	movlw 	0x07
	movwf 	LD
	call	Send
;26
	movlw	0x00
	movwf 	HD
	movlw 	0x07
	movwf 	LD
	call	Send
;27
	movlw	0x00
	movwf 	HD
	movlw 	0x0F
	movwf 	LD
	call	Send
;28
	movlw	0x00
	movwf 	HD
	movlw 	0x18
	movwf 	LD
	call	Send
;29
    	movlw	0x10
	movwf 	HD
	movlw 	0xFF
	movwf 	LD
	call	Send
;30
	movlw	0x07
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;31
	movlw	0x0C
	movwf 	HD
	movlw 	0x07
	movwf 	LD
	call	Send
;32
	movlw	0x18
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
	
	call      	Set_address
	
;New_Column    ---6--

;1	
	call 	Send_zero

;2	
	call 	Send_zero

;3
	call 	Send_zero
;4
	call 	Send_zero
;5
	call 	Send_zero
;6
	call 	Send_zero
;7
	call 	Send_zero
;8
	call 	Send_zero
;9
	call 	Send_zero
;10
	call 	Send_zero
;11
	call 	Send_zero
;12
	call 	Send_zero
;13
	movlw	0xF0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;14
	movlw	0x1C
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;15
	movlw	0x0E
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;16
	movlw	0x03
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;17
	movlw	0x01
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send
;18
	movlw	0x19
	movwf 	HD
	movlw 	0xC0
	movwf 	LD
	call	Send
;19
	movlw	0xF1
	movwf 	HD
	movlw 	0xC0
	movwf 	LD
	call	Send
;20
	movlw	0x00
	movwf 	HD
	movlw 	0xC0
	movwf 	LD
	call	Send
;21
	movlw	0x00
	movwf 	HD
	movlw 	0xC0
	movwf 	LD
	call	Send
;22
	movlw	0x00
	movwf 	HD
	movlw 	0x60
	movwf 	LD
	call	Send
;23
	movlw	0x00
	movwf 	HD
	movlw 	0x60
	movwf 	LD
	call	Send
;24
	movlw	0x00
	movwf 	HD
	movlw 	0x60
	movwf 	LD
	call	Send
;25
	movlw	0x0E
	movwf 	HD
	movlw 	0xE0
	movwf 	LD
	call	Send
;26
	movlw	0x7E
	movwf 	HD
	movlw 	0xE0
	movwf 	LD
	call	Send
;27
	movlw	0x80
	movwf 	HD
	movlw 	0x20
	movwf 	LD
	call	Send
;28
	movlw	0x00
	movwf 	HD
	movlw 	0x60
	movwf 	LD
	call	Send
;29
    	movlw	0xFF
	movwf 	HD
	movlw 	0x07
	movwf 	LD
	call	Send
;30
	call 	Send_zero
;31
	call 	Send_zero
;32
	call 	Send_zero
	
	call      	Set_address


;New_Column    --7--

;1	
	call 	Send_zero

;2	
	call 	Send_zero

;3
	call 	Send_zero
;4
	call 	Send_zero
;5
	call 	Send_zero
;6
	call 	Send_zero
;7
	call 	Send_zero
;8
	call 	Send_zero
;9
	call 	Send_zero
;10
	call 	Send_zero
;11
	call 	Send_zero
;12
	call 	Send_zero
;13
	call 	Send_zero
;14
	call 	Send_zero
;15
	call 	Send_zero
;16
	call 	Send_zero
;17
	call 	Send_zero
;18
	call 	Send_zero
;19
	call 	Send_zero
;20
	call 	Send_zero
;21
	call 	Send_zero
;22
	call 	Send_zero
;23
	call 	Send_zero
;24
	call 	Send_zero
;25
	call 	Send_zero
;26
	call 	Send_zero
;27
	call 	Send_zero
;28
	call 	Send_zero
;29
    	movlw	0xF8
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;30
	movlw	0x0F
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;31
	movlw	0x03
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send
;32
	movlw	0x03
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send
	
	call      	Set_address

;New_Column    --8--

call	ZERO
	
	call      	Set_address


;New_Column    --9--

call	ZERO
	
	call      	Set_address


;New_Column    --10--

call	ZERO
	call      	Set_address

;New_Column    --11--

	call	ZERO
	
	call      	Set_address

;New_Column    --12--

	call	ZERO
	
	call      	Set_address

;New_Column    --13--

;1	
	movlw	0x03
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send

;2	
	movlw	0x30
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send

;3
	movlw	0xE0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;4
	movlw	0xc0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;5
	movlw	0xc0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;6
	movlw	0xc0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;7
	movlw	0xc0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;8
	movlw	0x60
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;9
	movlw	0xC0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;10
	movlw	0xC0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;11
	movlw	0xC0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;12
	movlw	0x60
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;13
	movlw	0x30
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;14
	movlw	0x18
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;15
	movlw	0x18
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;16
    movlw	0x18
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;17
	movlw	0x18
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;18
	movlw	0x0C
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;19
	movlw	0x07
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;20
	movlw	0x03
	movwf 	HD
	movlw 	0xC0
	movwf 	LD
	call	Send
;21
	movlw	0x03
	movwf 	HD
	movlw 	0xFE
	movwf 	LD
	call	Send
;22
	movlw	0x03
	movwf 	HD
	movlw 	0x81
	movwf 	LD
	call	Send
;23
	movlw	0x10
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send
;24
	movlw	0x00
	movwf 	HD
	movlw 	0xC0
	movwf 	LD
	call	Send
;25
	movlw	0x00
	movwf 	HD
	movlw 	0xc0
	movwf 	LD
	call	Send
;26
	movlw	0x00
	movwf 	HD
	movlw 	0x60
	movwf 	LD
	call	Send
;27
	movlw	0x00
	movwf 	HD
	movlw 	0x70
	movwf 	LD
	call	Send
;28
    	call 	Send_zero
;29
    	call 	Send_zero
;30
	call 	Send_zero
;31
	call 	Send_zero
;32
	call 	Send_zero

call      	Set_address

;New_Column    ---14--

;1	
	call 	Send_zero

;2	
	movlw	0x0F
	movwf 	HD
	movlw 	0xFF
	movwf 	LD
	call	Send


;3
	call 	Send_zero
;4
	call 	Send_zero
;5
	call 	Send_zero
;6
	call 	Send_zero
;7
	call 	Send_zero
;8
	movlw	0x0C
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;9
	movlw	0x0F
	movwf 	HD
	movlw 	0xFF
	movwf 	LD
	call	Send
;10
	movlw	0x0F
	movwf 	HD
	movlw 	0xFF
	movwf 	LD
	call	Send
;11
	call 	Send_zero
;12
	call 	Send_zero
;13
	call 	Send_zero
;14
	call 	Send_zero
;15
	movlw	0x1f
	movwf 	HD
	movlw 	0xE0
	movwf 	LD
	call	Send
;16
	movlw	0x00
	movwf 	HD
	movlw 	0x3F
	movwf 	LD
	call	Send
;17
	call 	Send_zero
;18
	call 	Send_zero
;19
	call 	Send_zero
;20
	call 	Send_zero
;21
	movlw	0x00
	movwf 	HD
	movlw 	0x0F
	movwf 	LD
	call	Send

;22
	movlw	0xFF
	movwf 	HD
	movlw 	0xFF
	movwf 	LD
	call	Send
;23
	movlw	0x00
	movwf 	HD
	movlw 	0x10
	movwf 	LD
	call	Send
;24
	call 	Send_zero
;25
	call 	Send_zero
;26
	call 	Send_zero
;27
	call 	Send_zero
;28
	call 	Send_zero
;29
    	call 	Send_zero
;30
	call 	Send_zero
;31
	call 	Send_zero
;32
	call 	Send_zero
	
	call      	Set_address



;New_Column    --15--

;1	
	movlw	0x07
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send

;2	
	movlw	0xFC
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send

;3
	movlw	0x3F
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;4
	movlw	0x10
	movwf 	HD
	movlw 	0xC0
	movwf 	LD
	call	Send
;5
	movlw	0xc0
	movwf 	HD
	movlw 	0xE0
	movwf 	LD
	call	Send
;6
	movlw	0x00
	movwf 	HD
	movlw 	0x70
	movwf 	LD
	call	Send
;7
	movlw	0x00
	movwf 	HD
	movlw 	0xE0
	movwf 	LD
	call	Send
;8
	movlw	0x10
	movwf 	HD
	movlw 	0xC0
	movwf 	LD
	call	Send
;9
	movlw	0x83
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send
;10
	movlw	0xFE
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;11
	movlw	0x07
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;12
	movlw	0x03
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;13
	movlw	0x03
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;14
	movlw	0x03
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;15
	movlw	0x0E
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;16
    	movlw	0xF8
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;17
	call 	Send_zero
;18
	call 	Send_zero
;19
	call 	Send_zero
;20
	call 	Send_zero
;21
	call 	Send_zero
;22
	movlw	0x80
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;23
	movlw	0x80
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;24
	movlw	0xC0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;25
	movlw	0x70
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;26
	movlw	0x38
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;27
	call 	Send_zero
;28
   	call 	Send_zero
;29
    	call 	Send_zero
;30
	call 	Send_zero
;31
	call 	Send_zero
;32
	call 	Send_zero
	
	call      	Set_address



;New_Column    --16--

call	ZERO
	
return 

;********************************************************


AHMAD_T
;New_Column    --1--
	movlw	0x7F
	movwf 	adress_y
	movlw	0x80
	movwf	adress_x
;1	

call 	Send_zero

;2	
call 	Send_zero       

;3
call 	Send_zero
;4
call 	Send_zero
;5
call 	Send_zero
;6
call 	Send_zero
;7
call 	Send_zero
;8
call 	Send_zero
;9
call 	Send_zero
;10
call 	Send_zero
;11
call 	Send_zero
;12
call 	Send_zero
;13
call 	Send_zero
;14
	movlw	0x06
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;15
	movlw	0x1c
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;16
    movlw	0xc3
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;17
	movlw	0x3f
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send
;18
	movlw	0x3f
	movwf 	HD
	movlw 	0xf8
	movwf 	LD
	call	Send
;19
	movlw	0x1f
	movwf 	HD
	movlw 	0xff
	movwf 	LD
	call	Send
;20
	movlw	0x07
	movwf 	HD
	movlw 	0xff
	movwf 	LD
	call	Send
;21
	movlw	0x00
	movwf 	HD
	movlw 	0x7f
	movwf 	LD
	call	Send
;22
call 	Send_zero
;23
call 	Send_zero
;24
call 	Send_zero
;25
call 	Send_zero
;26
call 	Send_zero
;27
call 	Send_zero
;28
call 	Send_zero
;29
call 	Send_zero
;30
call 	Send_zero
;31
call 	Send_zero
;32
call 	Send_zero


	call      Set_address

;************************
;New_Column    --2--

	
;1	
call 	Send_zero

;2	
call 	Send_zero       

;3
call 	Send_zero
;4
call 	Send_zero
;5
call 	Send_zero
;6
call 	Send_zero
;7
call 	Send_zero
;8
call 	Send_zero
;9
call 	Send_zero
;10
call 	Send_zero
;11
	movlw	0x7f
	movwf 	HD
	movlw 	0xf0
	movwf 	LD
	call	Send
;12
	movlw	0x7f
	movwf 	HD
	movlw 	0xf0
	movwf 	LD
	call	Send
;13
	movlw	0x10
	movwf 	HD
	movlw 	0xc0
	movwf 	LD
	call	Send
;14
call 	Send_zero
;15
call 	Send_zero
;16
call 	Send_zero
;17
call 	Send_zero
;18
call 	Send_zero
;19
	movlw	0xff
	movwf 	HD
	movlw 	0xff
	movwf 	LD
	call	Send
;20
	movlw	0xff
	movwf 	HD
	movlw 	0xff
	movwf 	LD
	call	Send
;21
	movlw	0xff
	movwf 	HD
	movlw 	0xff
	movwf 	LD
	call	Send
;22
	movlw	0x7f
	movwf 	HD
	movlw 	0xe0
	movwf 	LD
	call	Send
;23
call 	Send_zero
;24
call 	Send_zero
;25
call 	Send_zero
;26
call 	Send_zero
;27
call 	Send_zero
;28
call 	Send_zero
;29
call 	Send_zero
;30
call 	Send_zero
;31
call 	Send_zero
;32
call 	Send_zero
	
	call      Set_address
;************************
;New_Column    --3--

	
;1	
call 	Send_zero

;2	
call 	Send_zero       

;3
call 	Send_zero
;4
call 	Send_zero
;5
call 	Send_zero
;6
call 	Send_zero
;7
call 	Send_zero
;8
call 	Send_zero
;9
call 	Send_zero
;10
call 	Send_zero
;11
call 	Send_zero
;12
call 	Send_zero
;13
call 	Send_zero
;14
	movlw	0x03
	movwf 	HD
	movlw 	0xc0
	movwf 	LD
	call	Send
;15
	movlw	0x07
	movwf 	HD
	movlw 	0xc0
	movwf 	LD
	call	Send
;16
    movlw	0x03
	movwf 	HD
	movlw 	0xc0
	movwf 	LD
	call	Send
;17
	movlw	0x01
	movwf 	HD
	movlw 	0xc0
	movwf 	LD
	call	Send
;18
	movlw	0x07
	movwf 	HD
	movlw 	0xc0
	movwf 	LD
	call	Send
;19
	movlw	0xff
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;20
	movlw	0xfe
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;21
	movlw	0xf0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;22
call 	Send_zero
;23
call 	Send_zero
;24
call 	Send_zero
;25
call 	Send_zero
;26
call 	Send_zero
;27
call 	Send_zero
;28
call 	Send_zero
;29
call 	Send_zero
;30
call 	Send_zero
;31
call 	Send_zero
;32
call 	Send_zero
	
	call      Set_address
;************************

;New_Column    --4--

		
	call	ZERO
	
	call      Set_address
;************************
;New_Column    --5--

	
;1	
call 	Send_zero

;2	
call 	Send_zero       

;3
call 	Send_zero
;4
call 	Send_zero
;5
call 	Send_zero
;6
call 	Send_zero
;7
call 	Send_zero
;8
call 	Send_zero
;9
call 	Send_zero
;10
call 	Send_zero
;11
call 	Send_zero
;12
call 	Send_zero
;13
call 	Send_zero
;14
call 	Send_zero
;15
call 	Send_zero
;16
call 	Send_zero
;17
call 	Send_zero
;18
call 	Send_zero
;19
call 	Send_zero
;20
call 	Send_zero
;21
call 	Send_zero
;22
	movlw	0x00
	movwf 	HD
	movlw 	0x07
	movwf 	LD
	call	Send
;23
	movlw	0x00
	movwf 	HD
	movlw 	0x1c
	movwf 	LD
	call	Send
;24
	movlw	0x00
	movwf 	HD
	movlw 	0x38
	movwf 	LD
	call	Send
;25
	movlw	0x00
	movwf 	HD
	movlw 	0x70
	movwf 	LD
	call	Send
;26
	movlw	0x00
	movwf 	HD
	movlw 	0x70
	movwf 	LD
	call	Send
;27
	movlw	0x00
	movwf 	HD
	movlw 	0xf8
	movwf 	LD
	call	Send
;28
    movlw	0x03
	movwf 	HD
	movlw 	0x84
	movwf 	LD
	call	Send
;29
    movlw	0x03
	movwf 	HD
	movlw 	0x07
	movwf 	LD
	call	Send
;30
	movlw	0x06
	movwf 	HD
	movlw 	0x03
	movwf 	LD
	call	Send
;31
	movlw	0x0c
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;32
	movlw	0x0c
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
	

	call      Set_address
;************************
;New_Column    --6--

;1	
call 	Send_zero

;2	
call 	Send_zero       

;3
call 	Send_zero
;4
call 	Send_zero
;5
call 	Send_zero
;6
call 	Send_zero
;7
call 	Send_zero
;8
	movlw	0x03
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send
;9
	movlw	0x0f
	movwf 	HD
	movlw 	0xf0
	movwf 	LD
	call	Send
;10
	movlw	0x18
	movwf 	HD
	movlw 	0x18
	movwf 	LD
	call	Send
;11
	movlw	0x18
	movwf 	HD
	movlw 	0x1f
	movwf 	LD
	call	Send
;12
	movlw	0x18
	movwf 	HD
	movlw 	0x18
	movwf 	LD
	call	Send
;13
	movlw	0x18
	movwf 	HD
	movlw 	0x18
	movwf 	LD
	call	Send
;14
	movlw	0x1c
	movwf 	HD
	movlw 	0x18
	movwf 	LD
	call	Send
;15
	movlw	0x32
	movwf 	HD
	movlw 	0x18
	movwf 	LD
	call	Send
;16
    movlw	0x30
	movwf 	HD
	movlw 	0x0f
	movwf 	LD
	call	Send
;17
	movlw	0x30
	movwf 	HD
	movlw 	0x08
	movwf 	LD
	call	Send
;18
	movlw	0x30
	movwf 	HD
	movlw 	0x08
	movwf 	LD
	call	Send
;19
	movlw	0x18
	movwf 	HD
	movlw 	0x18
	movwf 	LD
	call	Send
;20
	movlw	0x18
	movwf 	HD
	movlw 	0x08
	movwf 	LD
	call	Send
;21
	movlw	0x1c
	movwf 	HD
	movlw 	0x0f
	movwf 	LD
	call	Send
;22
	movlw	0xf0
	movwf 	HD
	movlw 	0x06
	movwf 	LD
	call	Send
;23
	movlw	0x38
	movwf 	HD
	movlw 	0x0e
	movwf 	LD
	call	Send
;24
	movlw	0x0c
	movwf 	HD
	movlw 	0x0e
	movwf 	LD
	call	Send
;25
	movlw	0x04
	movwf 	HD
	movlw 	0x0e
	movwf 	LD
	call	Send
;26
	movlw	0x3f
	movwf 	HD
	movlw 	0x84
	movwf 	LD
	call	Send
;27
	movlw	0xf0
	movwf 	HD
	movlw 	0xf8
	movwf 	LD
	call	Send
;28
    movlw	0xe0
	movwf 	HD
	movlw 	0x6f
	movwf 	LD
	call	Send
;29
    movlw	0x77
	movwf 	HD
	movlw 	0xc1
	movwf 	LD
	call	Send
;30
	movlw	0x98
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;31
	movlw	0xce
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;32
	movlw	0xe7
	movwf 	HD
	movlw 	0xc0
	movwf 	LD
	call	Send
	
	call      Set_address
;************************
;;New_Column    --7--

	
;1	
call 	Send_zero

;2	
call 	Send_zero       

;3
call 	Send_zero
;4
call 	Send_zero
;5
call 	Send_zero
;6
call 	Send_zero
;7
call 	Send_zero
;8
call 	Send_zero
;9
call 	Send_zero
;10
call 	Send_zero
;11
	movlw	0xc0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;12
	movlw	0x60
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;13
	movlw	0x30
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;14
	movlw	0x18
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;15
	movlw	0x18
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;16
    movlw	0x0c
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;17
	movlw	0x0c
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;18
	movlw	0x0C
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;19
	movlw	0x0c
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;20
	movlw	0x0c
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;21
	movlw	0x0c
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;22
	movlw	0x06
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;23
	movlw	0x06
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;24
	movlw	0x06
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;25
	movlw	0x03
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;26
	movlw	0x03
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;27
	movlw	0x03
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;28
    movlw	0x83
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;29
    movlw	0xe3
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;30
	movlw	0x1f
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;31
	movlw	0x07
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;32
	movlw	0x01
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send
	
	call      Set_address
;************************
;New_Column    --8--

	
	call	ZERO
	call      Set_address
 	
;************************
;New_Column    --9--

		
	call	ZERO
	
	call      Set_address

;************************
;New_Column    --10--

		
	call	ZERO
	
	call      Set_address

;************************
;New_Column    --11--

	
call	ZERO
	
	call      Set_address

;************************
;New_Column    --12--
	
call	ZERO
	
	call      Set_address

;************************
;New_Column    --13--
	
;1	
	movlw	0x0c
	movwf 	HD
	movlw 	0xe0
	movwf 	LD
	call	Send

;2	
	movlw	0x18
	movwf 	HD
	movlw 	0x38
	movwf 	LD
	call	Send

;3
	movlw	0x18
	movwf 	HD
	movlw 	0x7c
	movwf 	LD
	call	Send
;4
	movlw	0x18
	movwf 	HD
	movlw 	0x0f
	movwf 	LD
	call	Send
;5
	movlw	0x18
	movwf 	HD
	movlw 	0x03
	movwf 	LD
	call	Send
;6
	movlw	0x18
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;7
	movlw	0x18
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;8
	movlw	0x0c
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;9
	movlw	0x0c
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;10
	movlw	0x0c
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;11
	movlw	0x06
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;12
	movlw	0x03
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;13
	movlw	0x01
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send
;14
	movlw	0x00
	movwf 	HD
	movlw 	0xc0
	movwf 	LD
	call	Send
;15
	movlw	0x00
	movwf 	HD
	movlw 	0x60
	movwf 	LD
	call	Send
;16
    movlw	0x00
	movwf 	HD
	movlw 	0x7c
	movwf 	LD
	call	Send
;17
	movlw	0x00
	movwf 	HD
	movlw 	0x77
	movwf 	LD
	call	Send
;18
	movlw	0x00
	movwf 	HD
	movlw 	0x60
	movwf 	LD
	call	Send
;19
call 	Send_zero
;20
call 	Send_zero
;21
call 	Send_zero
;22
call 	Send_zero
;23
call 	Send_zero
;24
call 	Send_zero
;25
call 	Send_zero
;26
call 	Send_zero
;27
call 	Send_zero
;28
call 	Send_zero
;29
call 	Send_zero
;30
call 	Send_zero
;31
call 	Send_zero
;32
call 	Send_zero
	
	call      Set_address
;************************
;New_Column    --14--

	
;1	
	movlw	0x3f
	movwf 	HD
	movlw 	0xf0
	movwf 	LD
	call	Send

;2	
	movlw	0x19
	movwf 	HD
	movlw 	0x8e
	movwf 	LD
	call	Send

;3
	movlw	0x7f
	movwf 	HD
	movlw 	0x1b
	movwf 	LD
	call	Send
;4
	movlw	0xc8
	movwf 	HD
	movlw 	0x70
	movwf 	LD
	call	Send
;5
	movlw	0xfb
	movwf 	HD
	movlw 	0xe0
	movwf 	LD
	call	Send
;6
	movlw	0x32
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;7
	movlw	0x00
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;8
	movlw	0x00
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;9
	movlw	0x00
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;10
	movlw	0x00
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;11
	movlw	0x03
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send
;12
	movlw	0x00
	movwf 	HD
	movlw 	0xe0
	movwf 	LD
	call	Send
;13
	movlw	0x00
	movwf 	HD
	movlw 	0x30
	movwf 	LD
	call	Send
;14
	movlw	0x00
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;15
	movlw	0x00
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;16
    movlw	0x00
	movwf 	HD
	movlw 	0x18
	movwf 	LD
	call	Send
;17
	movlw	0xcc
	movwf 	HD
	movlw 	0x18
	movwf 	LD
	call	Send
;18
	movlw	0xc0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;19
call 	Send_zero
;20
call 	Send_zero
;21
call 	Send_zero
;22
call 	Send_zero
;23
call 	Send_zero
;24
call 	Send_zero
;25
call 	Send_zero
;26
call 	Send_zero
;27
call 	Send_zero
;28
call 	Send_zero
;29
call 	Send_zero
;30
call 	Send_zero
;31
call 	Send_zero
;32
call 	Send_zero
	
	call      Set_address
;************************
;New_Column    --15--
	
;1	
	movlw	0x00
	movwf 	HD
	movlw 	0xc0
	movwf 	LD
	call	Send

;2	
	movlw	0x00
	movwf 	HD
	movlw 	0x60
	movwf 	LD
	call	Send

;3
	movlw	0x80
	movwf 	HD
	movlw 	0x70
	movwf 	LD
	call	Send
;4
	movlw	0xc0
	movwf 	HD
	movlw 	0x70
	movwf 	LD
	call	Send
;5
	movlw	0x70
	movwf 	HD
	movlw 	0x30
	movwf 	LD
	call	Send
;6
	movlw	0x18
	movwf 	HD
	movlw 	0x30
	movwf 	LD
	call	Send
;7
	movlw	0x06
	movwf 	HD
	movlw 	0x30
	movwf 	LD
	call	Send
;8
	movlw	0x00
	movwf 	HD
	movlw 	0x70
	movwf 	LD
	call	Send
;9
	movlw	0x00
	movwf 	HD
	movlw 	0x70
	movwf 	LD
	call	Send
;10
	movlw	0x00
	movwf 	HD
	movlw 	0x60
	movwf 	LD
	call	Send
;11
	movlw	0x00
	movwf 	HD
	movlw 	0xc0
	movwf 	LD
	call	Send
;12
	movlw	0x00
	movwf 	HD
	movlw 	0xc0
	movwf 	LD
	call	Send
;13
	movlw	0x01
	movwf 	HD
	movlw 	0x08
	movwf 	LD
	call	Send
;14
	movlw	0x03
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;15
	movlw	0x03
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;16
    movlw	0x06
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;17
	movlw	0x06
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;18
	movlw	0x06
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;19
call 	Send_zero
;20
call 	Send_zero
;21
call 	Send_zero
;22
call 	Send_zero
;23
call 	Send_zero
;24
call 	Send_zero
;25
call 	Send_zero
;26
call 	Send_zero
;27
call 	Send_zero
;28
call 	Send_zero
;29
call 	Send_zero
;30
call 	Send_zero
;31
call 	Send_zero
;32
call 	Send_zero
	
	call      Set_address
;************************
;New_Column    --16--

	
call	ZERO

;************************
RETURN 


AHMAD_G
;New_Column    --1--

	movlw	0x7F
	movwf 	adress_y
	movlw	0x80
	movwf	adress_x	
;1	
call 	Send_zero

;2	
call 	Send_zero       

;3
call 	Send_zero
;4
call 	Send_zero
;5
call 	Send_zero
;6
call 	Send_zero
;7
call 	Send_zero
;8
call 	Send_zero
;9
call 	Send_zero
;10
call 	Send_zero
;11
call 	Send_zero
;12
call 	Send_zero
;13
call 	Send_zero
;14
call 	Send_zero
;15
call 	Send_zero
;16
    movlw	0x00
	movwf 	HD
	movlw 	0x01
	movwf 	LD
	call	Send
;17
	movlw	0x00
	movwf 	HD
	movlw 	0x01
	movwf 	LD
	call	Send
;18
	movlw	0x00
	movwf 	HD
	movlw 	0x01
	movwf 	LD
	call	Send
;19
	movlw	0x00
	movwf 	HD
	movlw 	0x03
	movwf 	LD
	call	Send
;20
	movlw	0x00
	movwf 	HD
	movlw 	0x03
	movwf 	LD
	call	Send
;21
	movlw	0x00
	movwf 	HD
	movlw 	0x03
	movwf 	LD
	call	Send
;22
call 	Send_zero
;23
call 	Send_zero
;24
call 	Send_zero
;25
call 	Send_zero
;26
call 	Send_zero
;27
call 	Send_zero
;28
call 	Send_zero
;29
call 	Send_zero
;30

call 	Send_zero
;31
call 	Send_zero
;32
call 	Send_zero
	
	call      Set_address
;************************
;New_Column    --2--


;1	
call 	Send_zero

;2	
call 	Send_zero
;3
call 	Send_zero
;4
call 	Send_zero
;5
call 	Send_zero
;6
call 	Send_zero
;7
	movlw	0x0f
	movwf 	HD
	movlw 	0xf8
	movwf 	LD
	call	Send
;8
	movlw	0x7f
	movwf 	HD
	movlw 	0xff
	movwf 	LD
	call	Send
;9
	movlw	0xff
	movwf 	HD
	movlw 	0xff
	movwf 	LD
	call	Send
;10
	movlw	0x00
	movwf 	HD
	movlw 	0x7f
	movwf 	LD
	call	Send
;11
	movlw	0x00
	movwf 	HD
	movlw 	0xf8
	movwf 	LD
	call	Send
;12
	movlw	0x07
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send
;13
	movlw	0x1c
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;14
	movlw	0x70
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;15
	movlw	0xe0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;16
    movlw	0xc0
	movwf 	HD
	movlw 	0x03
	movwf 	LD
	call	Send
;17
	movlw	0xe0
	movwf 	HD
	movlw 	0x07
	movwf 	LD
	call	Send
;18
	movlw	0xe0
	movwf 	HD
	movlw 	0x07
	movwf 	LD
	call	Send
;19
	movlw	0xc0
	movwf 	HD
	movlw 	0x01
	movwf 	LD
	call	Send
;20
	movlw	0xe0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;21
	movlw	0xf8
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;22
	movlw	0xfe
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;23
	movlw	0xff
	movwf 	HD
	movlw 	0xe0
	movwf 	LD
	call	Send
;24
	movlw	0xff
	movwf 	HD
	movlw 	0xff
	movwf 	LD
	call	Send
;25
	movlw	0x3f
	movwf 	HD
	movlw 	0xff
	movwf 	LD
	call	Send
;26
	movlw	0x07
	movwf 	HD
	movlw 	0xff
	movwf 	LD
	call	Send
;27
	movlw	0x00
	movwf 	HD
	movlw 	0x3f
	movwf 	LD
	call	Send
;28
call 	Send_zero
;29
call 	Send_zero
;30
call 	Send_zero
;31

call 	Send_zero
;32

call 	Send_zero
	
	call      Set_address
;************************
;New_Column    --3--

	
;1	

call 	Send_zero

;2	

call 	Send_zero

;3

call 	Send_zero
;4

call 	Send_zero
;5

call 	Send_zero
;6

call 	Send_zero
;7

call 	Send_zero
;8
	movlw	0xff
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send
;9
	movlw	0xff
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;10
	movlw	0xce
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;11

call 	Send_zero
;12

call 	Send_zero
;13

call 	Send_zero
;14

call 	Send_zero
;15

call 	Send_zero
;16

call 	Send_zero
;17
	movlw	0xc0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;18
	movlw	0xc0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;19

call 	Send_zero
;20

call 	Send_zero
;21

call 	Send_zero
;22

call 	Send_zero
;23
	movlw	0x00
	movwf 	HD
	movlw 	0x01
	movwf 	LD
	call	Send
;24
	movlw	0xff
	movwf 	HD
	movlw 	0xff
	movwf 	LD
	call	Send
;25
	movlw	0xff
	movwf 	HD
	movlw 	0xfc
	movwf 	LD
	call	Send
;26
	movlw	0xff
	movwf 	HD
	movlw 	0xc0
	movwf 	LD
	call	Send
;27
	movlw	0xfc
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;28

call 	Send_zero
;29
 
call 	Send_zero
;30

call 	Send_zero
;31

call 	Send_zero
;32

call 	Send_zero
	
	call      Set_address
;************************
;New_Column    --4--


;1	
call 	Send_zero

;2	
call 	Send_zero       

;3
call 	Send_zero
;4
call 	Send_zero
;5
call 	Send_zero
;6
call 	Send_zero
;7
call 	Send_zero
;8
call 	Send_zero
;9
call 	Send_zero
;10
call 	Send_zero
;11
call 	Send_zero
;12
call 	Send_zero
;13
call 	Send_zero
;14
call 	Send_zero
;15
call 	Send_zero
;16
call 	Send_zero
;17
call 	Send_zero
;18
call 	Send_zero
;19
call 	Send_zero
;20
call 	Send_zero
;21
call 	Send_zero
;22
call 	Send_zero
;23

	movlw	0x80
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;24

	movlw	0x80
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;25
call 	Send_zero
;26
call 	Send_zero
;27
call 	Send_zero
;28
call 	Send_zero
;29
call 	Send_zero
;30
call 	Send_zero
;31
call 	Send_zero
;32
call 	Send_zero
	
	call      Set_address
;************************
;New_Column    --5--

;1	
call 	Send_zero

;2	
call 	Send_zero       

;3
call 	Send_zero
;4
call 	Send_zero
;5
call 	Send_zero
;6
call 	Send_zero
;7
call 	Send_zero
;8
call 	Send_zero
;9
call 	Send_zero
;10
call 	Send_zero
;11
call 	Send_zero
;12
call 	Send_zero
;13
call 	Send_zero
;14

	movlw	0x00
	movwf 	HD
	movlw 	0x01
	movwf 	LD
	call	Send
;15

	movlw	0x00
	movwf 	HD
	movlw 	0x03
	movwf 	LD
	call	Send
;16

	movlw	0x00
	movwf 	HD
	movlw 	0x03
	movwf 	LD
	call	Send
;17

	movlw	0x00
	movwf 	HD
	movlw 	0x07
	movwf 	LD
	call	Send
;18

	movlw	0x00
	movwf 	HD
	movlw 	0x06
	movwf 	LD
	call	Send
;19

	movlw	0x00
	movwf 	HD
	movlw 	0x0e
	movwf 	LD
	call	Send
;20

	movlw	0x00
	movwf 	HD
	movlw 	0x0c
	movwf 	LD
	call	Send
;21

	movlw	0x00
	movwf 	HD
	movlw 	0x0c
	movwf 	LD
	call	Send
;22

	movlw	0x00
	movwf 	HD
	movlw 	0x18
	movwf 	LD
	call	Send
;23

	movlw	0x00
	movwf 	HD
	movlw 	0x18
	movwf 	LD
	call	Send
;24

	movlw	0x00
	movwf 	HD
	movlw 	0x30
	movwf 	LD
	call	Send
;25

	movlw	0x00
	movwf 	HD
	movlw 	0x20
	movwf 	LD
	call	Send
;26

	movlw	0x00
	movwf 	HD
	movlw 	0x60
	movwf 	LD
	call	Send
;27

	movlw	0x00
	movwf 	HD
	movlw 	0xe0
	movwf 	LD
	call	Send
;28

	movlw	0x01
	movwf 	HD
	movlw 	0xc1
	movwf 	LD
	call	Send
;29

	movlw	0x03
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send
;30

	movlw	0x03
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;31

	movlw	0x06
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;32

	movlw	0x06
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
	
call      Set_address
;************************
;New_Column    --6--
	
;1	

call 	Send_zero

;2	

call 	Send_zero

;3

call 	Send_zero
;4

call 	Send_zero
;5

call 	Send_zero
;6

call 	Send_zero
;7

call 	Send_zero
;8

call 	Send_zero
;9

call 	Send_zero
;10
	movlw	0x00
	movwf 	HD
	movlw 	0x60
	movwf 	LD
	call	Send
;11
	movlw	0x7f
	movwf 	HD
	movlw 	0xff
	movwf 	LD
	call	Send
;12
	movlw	0x67
	movwf 	HD
	movlw 	0x06
	movwf 	LD
	call	Send
;13
	movlw	0xc6
	movwf 	HD
	movlw 	0x06
	movwf 	LD
	call	Send
;14
	movlw	0x86
	movwf 	HD
	movlw 	0x07
	movwf 	LD
	call	Send
;15
	movlw	0xff
	movwf 	HD
	movlw 	0xf6
	movwf 	LD
	call	Send
;16
    movlw	0xe7
	movwf 	HD
	movlw 	0x0e
	movwf 	LD
	call	Send
;17
	movlw	0x7f
	movwf 	HD
	movlw 	0xff
	movwf 	LD
	call	Send
;18
	movlw	0x03
	movwf 	HD
	movlw 	0x03
	movwf 	LD
	call	Send
;19
	movlw	0x03
	movwf 	HD
	movlw 	0x03
	movwf 	LD
	call	Send
;20
	movlw	0x03
	movwf 	HD
	movlw 	0x03
	movwf 	LD
	call	Send
;21
	movlw	0x03
	movwf 	HD
	movlw 	0x03
	movwf 	LD
	call	Send
;22
	movlw	0x07
	movwf 	HD
	movlw 	0x03
	movwf 	LD
	call	Send
;23

call 	Send_zero
;24
	movlw	0x00
	movwf 	HD
	movlw 	0x20
	movwf 	LD
	call	Send
;25
	movlw	0x00
	movwf 	HD
	movlw 	0x20
	movwf 	LD
	call	Send
;26

call 	Send_zero
;27

call 	Send_zero
;28
    movlw	0xc0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;29

call 	Send_zero
;30
	movlw	0x38
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;31

call 	Send_zero
;32

call 	Send_zero
	
call      Set_address
;************************

;New_Column    --7--

;1	
	
call 	Send_zero

;2	

call 	Send_zero

;3

call 	Send_zero
;4

call 	Send_zero
;5

call 	Send_zero
;6

call 	Send_zero
;7

call 	Send_zero
;8
call 	Send_zero
;9

call 	Send_zero
;10
	movlw	0xe0
	movwf 	HD
	movlw 	0x60
	movwf 	LD
	call	Send
;11
	movlw	0xff
	movwf 	HD
	movlw 	0xf8
	movwf 	LD
	call	Send
;12
	movlw	0x07
	movwf 	HD
	movlw 	0x08
	movwf 	LD
	call	Send
;13
	movlw	0x02
	movwf 	HD
	movlw 	0x06
	movwf 	LD
	call	Send
;14
	movlw	0xf2
	movwf 	HD
	movlw 	0x07
	movwf 	LD
	call	Send
;15
	movlw	0x01
	movwf 	HD
	movlw 	0xff
	movwf 	LD
	call	Send
;16
	call 	Send_zero
;17
	movlw	0xff
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;18
	movlw	0x03
	movwf 	HD
	movlw 	0x3c
	movwf 	LD
	call	Send
;19
	movlw	0x03
	movwf 	HD
	movlw 	0x30
	movwf 	LD
	call	Send
;20
	movlw	0x03
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;21
	movlw	0x07
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;22
	movlw	0x1f
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send
;23
	movlw	0x78
	movwf 	HD
	movlw 	0x78
	movwf 	LD
	call	Send
;24
	movlw	0x7f
	movwf 	HD
	movlw 	0xff
	movwf 	LD
	call	Send
;25
	movlw	0x61
	movwf 	HD
	movlw 	0xc0
	movwf 	LD
	call	Send
;26
	movlw	0x38
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;27
	movlw	0x3c
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;28
    movlw	0xe7
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;29
    movlw	0x01
	movwf 	HD
	movlw 	0x88
	movwf 	LD
	call	Send
;30
	movlw	0x00
	movwf 	HD
	movlw 	0x8f
	movwf 	LD
	call	Send
;31
	movlw	0x03
	movwf 	HD
	movlw 	0xc0
	movwf 	LD
	call	Send
;32
	movlw	0x06
	movwf 	HD
	movlw 	0xc0
	movwf 	LD
	call	Send

call      Set_address
;************************
;New_Column    --8--

;1	
	call 	Send_zero

;2	
call 	Send_zero

;3
	call 	Send_zero
;4
	call 	Send_zero
;5
	call 	Send_zero
;6
	call 	Send_zero
;7
	call 	Send_zero
;8
	call 	Send_zero
;9
	call 	Send_zero
;10
	call 	Send_zero
;11
	call 	Send_zero
;12
	call 	Send_zero
;13
	call 	Send_zero
;14
	call 	Send_zero
;15
	movlw	0x80
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;16
    movlw	0xc0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;17
	movlw	0x60
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;18
	movlw	0x60
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;19
	movlw	0x60
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;20
	movlw	0x60
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;21
	movlw	0x60
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;22
	movlw	0x60
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;23
	movlw	0x60
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;24
	movlw	0xe0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;25
	movlw	0x70
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;26
	movlw	0x18
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;27
	movlw	0x1c
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;28
    movlw	0x0c
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;29
    movlw	0x0c
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;30
	movlw	0x0c
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;31
	movlw	0x04
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;32
	movlw	0x0c
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
	
call      Set_address
;************************
;New_Column    --9--
call	ZERO
	
call      Set_address
;************************
;New_Column    --10--


	call	ZERO
	call      Set_address
;************************
;New_Column    --11--

	
call	ZERO
	
	call      Set_address
;************************
;New_Column    --12--


call	ZERO
	
	call      Set_address
;************************
;New_Column    --13--

;1	
	movlw	0x06
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send

;2	
	movlw	0x06
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send

;3
	movlw	0x06
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;4
	movlw	0x06
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;5
	movlw	0x06
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;6
	movlw	0x06
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;7
	movlw	0x06
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;8
	movlw	0x06
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;9
	movlw	0x06
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;10
	movlw	0x07
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;11
	movlw	0x03
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;12
	movlw	0x03
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send
;13
	movlw	0x03
	movwf 	HD
	movlw 	0x83
	movwf 	LD
	call	Send
;14
	movlw	0x01
	movwf 	HD
	movlw 	0xc7
	movwf 	LD
	call	Send
;15
	movlw	0x01
	movwf 	HD
	movlw 	0xc0
	movwf 	LD
	call	Send
;16
    movlw	0x00
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send
;17
call 	Send_zero
;18
call 	Send_zero
;19
call 	Send_zero
;20
call 	Send_zero
;21
call 	Send_zero
;22
call 	Send_zero
;23
call 	Send_zero
;24
call 	Send_zero
;25
call 	Send_zero
;26
call 	Send_zero
;27
call 	Send_zero
;28
call 	Send_zero
;29
call 	Send_zero
;30
call 	Send_zero
;31
call 	Send_zero
;32
call 	Send_zero
	
	call      Set_address
;************************
;New_Column    --14--

	
;1	
call 	Send_zero

;2	
	movlw	0x00
	movwf 	HD
	movlw 	0x03
	movwf 	LD
	call	Send

;3
	movlw	0x00
	movwf 	HD
	movlw 	0x0e
	movwf 	LD
	call	Send
;4
call 	Send_zero
;5
call 	Send_zero
;6
call 	Send_zero
;7
call 	Send_zero
;8
call 	Send_zero
;9
call 	Send_zero
;10
	movlw	0x03
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;11
	movlw	0x0e
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;12
	movlw	0x78
	movwf 	HD
	movlw 	0xe1
	movwf 	LD
	call	Send
;13
	movlw	0xe0
	movwf 	HD
	movlw 	0x03
	movwf 	LD
	call	Send
;14
call 	Send_zero
;15
call 	Send_zero
;16
call 	Send_zero
;17
call 	Send_zero
;18
call 	Send_zero
;19
call 	Send_zero
;20
call 	Send_zero
;21
call 	Send_zero
;22
call 	Send_zero
;23
call 	Send_zero
;24
call 	Send_zero
;25
call 	Send_zero
;26
call 	Send_zero
;27
call 	Send_zero
;28
call 	Send_zero
;29
call 	Send_zero
;30
call 	Send_zero
;31
call 	Send_zero
;32
call 	Send_zero
	
	call      Set_address
;************************
;New_Column    --15--


;1	
	movlw	0x78
	movwf 	HD
	movlw 	0x60
	movwf 	LD
	call	Send

;2	
	movlw	0xe0
	movwf 	HD
	movlw 	0x30
	movwf 	LD
	call	Send

;3
	movlw	0x00
	movwf 	HD
	movlw 	0x10
	movwf 	LD
	call	Send
;4
call 	Send_zero
;5
call 	Send_zero
;6
call 	Send_zero
;7
call 	Send_zero
;8
	movlw	0x00
	movwf 	HD
	movlw 	0x03
	movwf 	LD
	call	Send
;9
	movlw	0x00
	movwf 	HD
	movlw 	0x06
	movwf 	LD
	call	Send
;10
	movlw	0x00
	movwf 	HD
	movlw 	0x1c
	movwf 	LD
	call	Send
;11
	movlw	0x00
	movwf 	HD
	movlw 	0x70
	movwf 	LD
	call	Send
;12
	movlw	0x01
	movwf 	HD
	movlw 	0xc0
	movwf 	LD
	call	Send
;13
	movlw	0xf3
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send
;14
	movlw	0x7f
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send
;15
	movlw	0x00
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send
;16
    movlw	0x01
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send
;17
	movlw	0x00
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send
;18
	movlw	0x00
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send
;19
call 	Send_zero
;20
call 	Send_zero
;21
call 	Send_zero
;22
call 	Send_zero
;23
call 	Send_zero
;24
call 	Send_zero
;25
call 	Send_zero
;26
call 	Send_zero
;27
call 	Send_zero
;28
call 	Send_zero
;29
call 	Send_zero
;30
call 	Send_zero
;31
call 	Send_zero
;32
call 	Send_zero
	
	call      Set_address
;************************
;New_Column    --16--


;1	
	movlw	0x0c
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send

;2	
	movlw	0x0c
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send

;3
	movlw	0x18
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;4
	movlw	0x18
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;5
	movlw	0x38
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;6
	movlw	0x60
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;7
	movlw	0xc0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;8
	movlw	0x80
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send
;9
call 	Send_zero
;10
call 	Send_zero
;11
call 	Send_zero
;12
call 	Send_zero
;13
call 	Send_zero
;14
call 	Send_zero
;15
call 	Send_zero
;16
call 	Send_zero
;17
call 	Send_zero
;18
call 	Send_zero
;19
call 	Send_zero
;20
call 	Send_zero
;21
call 	Send_zero
;22
call 	Send_zero
;23
call 	Send_zero
;24
call 	Send_zero
;25
call 	Send_zero
;26
call 	Send_zero
;27
call 	Send_zero
;28
call 	Send_zero
;29
call 	Send_zero
;30
call 	Send_zero
;31
call 	Send_zero
;32
call 	Send_zero
	
;************************
RETURN 
;************************



;this the second 
SARA_F 

;New_Column    --1--
	movlw	0x7F
	movwf 	adress_y
	movlw	0x80
	movwf	adress_x
;1	
	call 	Send_zero1

;2	
	call 	Send_zero1

;3 
call 	Send_zero1
;41
	call 	Send_zero1
;5
	call 	Send_zero1
;6
	call 	Send_zero1
;7
	call 	Send_zero1
;8
	call 	Send_zero1
;9
	call 	Send_zero1
;10
	call 	Send_zero1
;11
	call 	Send_zero1

;12
	call 	Send_zero1
;13
	movlw	0x00
	movwf 	HD
	movlw 	0x18
	movwf 	LD
	call	Send1
;14
	movlw	0x00
	movwf 	HD
	movlw 	0x38
	movwf 	LD
	call	Send1
;15
	movlw	0x00
	movwf 	HD
	movlw 	0xe0
	movwf 	LD
	call	Send1
;16
    movlw	0x00
	movwf 	HD
	movlw 	0xf8
	movwf 	LD
	call	Send1
;171
	movlw	0x01
	movwf 	HD
	movlw 	0xfc
	movwf 	LD
	call	Send1
;18
	movlw	0x00
	movwf 	HD
	movlw 	0xff
	movwf 	LD
	call	Send1
;19
	movlw	0x01
	movwf 	HD
	movlw 	0xff
	movwf 	LD
	call	Send1
;20
	movlw	0x00
	movwf 	HD
	movlw 	0xff
	movwf 	LD
	call	Send1
;21
	movlw	0x00
	movwf 	HD
	movlw 	0x3f
	movwf 	LD
	call	Send1
;22
	movlw	0x00
	movwf 	HD
	movlw 	0x1f
	movwf 	LD
	call	Send1
;23
	movlw	0x00
	movwf 	HD
	movlw 	0x03
	movwf 	LD
	call	Send1
;24
	call 	Send_zero1
;25
	call 	Send_zero1
;26
	call 	Send_zero1
;27
	call 	Send_zero1
;28
    call 	Send_zero1
;29
    call 	Send_zero1
;30
	call 	Send_zero1
;31
	call 	Send_zero1
;32
	call 	Send_zero1
	
	call      Set_address1

;New_Column    --2--

;1	
	call 	Send_zero1

;2	
	call 	Send_zero1

;3
	call 	Send_zero1
;4
	movlw	0x00
	movwf 	HD
	movlw 	0x01
	movwf 	LD
	call	Send1
;5
	movlw	0x00
	movwf 	HD
	movlw 	0x01
	movwf 	LD
	call	Send1
;6
	movlw	0x00
	movwf 	HD
	movlw 	0x01
	movwf 	LD
	call	Send1
;7
	call 	Send_zero1
;8
	call 	Send_zero1
;9
	call 	Send_zero1
;10
	call 	Send_zero1
;11
	call 	Send_zero1

;12
	call 	Send_zero1
;13
	call 	Send_zero1
;14
	call 	Send_zero1
;15
	call 	Send_zero1
;16
   call 	Send_zero1
;17
	call 	Send_zero1
;18
	call 	Send_zero1
;19
	movlw	0x80
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;20
	movlw	0xff
	movwf 	HD
	movlw 	0xff
	movwf 	LD
	call	Send1
;21
	movlw	0xff
	movwf 	HD
	movlw 	0xff
	movwf 	LD
	call	Send1
;22
	movlw	0xff
	movwf 	HD
	movlw 	0xff
	movwf 	LD
	call	Send1
;23
	movlw	0xff
	movwf 	HD
	movlw 	0x7f
	movwf 	LD
	call	Send1
;24
	call 	Send_zero1
;25
	call 	Send_zero1
;26
	call 	Send_zero1
;27
	call 	Send_zero1
;28
    call 	Send_zero1
;29
    call 	Send_zero1
;30
	call 	Send_zero1
;31
	call 	Send_zero1
;32
	call 	Send_zero1
	
call      Set_address1

;New_Column    --3--

;1	
	call 	Send_zero1

;2	
	call 	Send_zero1

;3
	call 	Send_zero1
;4
	movlw	0xe0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;5
	movlw	0xe0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;6
	movlw	0xe0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;7
	movlw	0x01
	movwf 	HD
	movlw 	0xf0
	movwf 	LD
	call	Send1
;8
	movlw	0x01
	movwf 	HD
	movlw 	0xf8
	movwf 	LD
	call	Send1
;9
	movlw	0x03
	movwf 	HD
	movlw 	0xf8
	movwf 	LD
	call	Send1
;10
	movlw	0x03
	movwf 	HD
	movlw 	0xf8
	movwf 	LD
	call	Send1
;11
	movlw	0x06
	movwf 	HD
	movlw 	0x0c
	movwf 	LD
	call	Send1

;12
	movlw	0x1f
	movwf 	HD
	movlw 	0x8c
	movwf 	LD
	call	Send1
;13
	movlw	0x1f
	movwf 	HD
	movlw 	0xfc
	movwf 	LD
	call	Send1
;14
	movlw	0x1f
	movwf 	HD
	movlw 	0xfc
	movwf 	LD
	call	Send1
;15
	movlw	0x07
	movwf 	HD
	movlw 	0xc4
	movwf 	LD
call	Send1
;16
    movlw	0x00
	movwf 	HD
	movlw 	0x04
	movwf 	LD
	call	Send1
;17
	movlw	0x00
	movwf 	HD
	movlw 	0x3c
	movwf 	LD
	call	Send1
;18
	movlw	0x03
	movwf 	HD
	movlw 	0xfc
	movwf 	LD
	call	Send1
;19
	movlw	0x3f
	movwf 	HD
	movlw 	0xfc
	movwf 	LD
call	Send1
;20
	movlw	0xff
	movwf 	HD
	movlw 	0xf0
	movwf 	LD
	call	Send1
;21
	movlw	0xff
	movwf 	HD
	movlw 	0xc0
	movwf 	LD
call	Send1
;22
	movlw	0xfe
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;23
	call 	Send_zero1
;24
call 	Send_zero1
;25
	call 	Send_zero1
;26
call 	Send_zero1
;27
call 	Send_zero1
;28
    call 	Send_zero1
;29
    call 	Send_zero1
;30
	call 	Send_zero1
;31
	call 	Send_zero1
;32
	call 	Send_zero1
	
call      Set_address1



;New_Column    --4--

;1	
	call 	Send_zero1

;2	
	call 	Send_zero1

;3
	call 	Send_zero1
;4
	call 	Send_zero1
;5
	call 	Send_zero1
;6
	call 	Send_zero1
;7
	call 	Send_zero1
;8
	call 	Send_zero1
;9
	call 	Send_zero1
;10
	call 	Send_zero1
;11
	call 	Send_zero1

;12
	call 	Send_zero1
;13
	call 	Send_zero1
;14
	call 	Send_zero1
;15
	call 	Send_zero1
;16
    call 	Send_zero1
;17
	call 	Send_zero1
;18
	call 	Send_zero1
;19
	call 	Send_zero1
;20
	call 	Send_zero1
;21
	movlw	0x00
	movwf 	HD
	movlw 	0xc0
	movwf 	LD
	call	Send1
;22
	call 	Send_zero1
;23
	movlw	0x00
	movwf 	HD
	movlw 	0x01
	movwf 	LD
	call	Send1
;24
	movlw	0x00
	movwf 	HD
	movlw 	0x02
	movwf 	LD
	call	Send1
;25
	movlw	0x00
	movwf 	HD
	movlw 	0x0e
	movwf 	LD
	call	Send1
;26
	movlw	0x00
	movwf 	HD
	movlw 	0x0c
	movwf 	LD
	call	Send1
;27
	movlw	0x00
	movwf 	HD
	movlw 	0x1c
	movwf 	LD
	call	Send1
;28
    movlw	0x00
	movwf 	HD
	movlw 	0xfc
	movwf 	LD
	call	Send1
;29
    movlw	0x00
	movwf 	HD
	movlw 	0xee
	movwf 	LD
	call	Send1
;30
	movlw	0x00
	movwf 	HD
	movlw 	0xc3
	movwf 	LD
	call	Send1
;31
	movlw	0x00
	movwf 	HD
	movlw 	0xc3
	movwf 	LD
	call	Send1
;32
	movlw	0x00
	movwf 	HD
	movlw 	0xe0
	movwf 	LD
	call	Send1
	
call      Set_address1


;New_Column    --5--

;1	
	call 	Send_zero1

;2	
	call 	Send_zero1

;3
	call 	Send_zero1
;4
	call 	Send_zero1
;5
	call 	Send_zero1
;6
	call 	Send_zero1
;7
	call 	Send_zero1
;8
	call 	Send_zero1
;9
	call 	Send_zero1
;10
	call 	Send_zero1
;11
	call 	Send_zero1

;12
	call 	Send_zero1
;13
	call 	Send_zero1
;14
	call 	Send_zero1
;15
	call 	Send_zero1
;16
    call 	Send_zero1
;17
	call 	Send_zero1
;18
	call 	Send_zero1
;19
	call 	Send_zero1
;20
	call 	Send_zero1
;21
	call 	Send_zero1
;22
	movlw	0x00
	movwf 	HD
	movlw 	0x0f
	movwf 	LD
	call	Send1
;2
	movlw	0xf8
	movwf 	HD
	movlw 	0x78
	movwf 	LD
	call	Send1
;24
	movlw	0x03
	movwf 	HD
	movlw 	0xe0
	movwf 	LD
	call	Send1
;25
	movlw	0x03
	movwf 	HD
	movlw 	0xe0
	movwf 	LD
	call	Send1
;26
	movlw	0x00
	movwf 	HD
	movlw 	0x70
	movwf 	LD
	call	Send1
;27
	movlw	0x00
	movwf 	HD
	movlw 	0x70
	movwf 	LD
	call	Send1
;28
    movlw	0x00
	movwf 	HD
	movlw 	0x18
	movwf 	LD
	call	Send1
;29
    movlw	0x00
	movwf 	HD
	movlw 	0x18
	movwf 	LD
	call	Send1
;30
	movlw	0x80
	movwf 	HD
	movlw 	0x08
	movwf 	LD
	call	Send1
;31
	movlw	0x80
	movwf 	HD
	movlw 	0x0e
	movwf 	LD
	call	Send1
;32
	movlw	0x70
	movwf 	HD
	movlw 	0x06
	movwf 	LD
	call	Send1
	
	call      Set_address1




;New_Column    --6--

;1	
	call 	Send_zero1

;2	
	call 	Send_zero1

;3
	call 	Send_zero1
;4
	call 	Send_zero1
;5
	call 	Send_zero1
;6
	call 	Send_zero1
;7
	call 	Send_zero1
;8
	call 	Send_zero1
;9
	call 	Send_zero1
;10
	call 	Send_zero1
;11
	call 	Send_zero1

;12
	call 	Send_zero1
;13
	call 	Send_zero1
;14
	call 	Send_zero1
;15
	call 	Send_zero1
;16
    call 	Send_zero1
;17
	call 	Send_zero1
;18
	call 	Send_zero1
;19
	movlw	0x00
	movwf 	HD
	movlw 	0x03
	movwf 	LD
	call	Send1
;20
	movlw	0x1f
	movwf 	HD
	movlw 	0xdf
	movwf 	LD
	call	Send1
;21
	movlw	0x1f
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send1
;22
	movlw	0x0f
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;23
	movlw	0x30
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;24
	movlw	0x1c
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;25
	movlw	0x0e
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;26
	movlw	0x0e
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;27
	movlw	0x03
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send1
;28
    movlw	0x01
	movwf 	HD
	movlw 	0xc0
	movwf 	LD
	call	Send1
;29
    movlw	0x01
	movwf 	HD
	movlw 	0xc0
	movwf 	LD
	call	Send1
;30
	movlw	0x01
	movwf 	HD
	movlw 	0xc0
	movwf 	LD
	call	Send1
;31
	movlw	0x01
	movwf 	HD
	movlw 	0xc0
	movwf 	LD
	call	Send1
;32
	movlw	0x00
	movwf 	HD
	movlw 	0x7f
	movwf 	LD
	call	Send1
	
call      Set_address1


;New_Column    --7--

;1	
	call 	Send_zero1

;2	
	call 	Send_zero1

;3
	call 	Send_zero1
;4
	call 	Send_zero1
;5
	call 	Send_zero1
;6
	call 	Send_zero1
;7
	call 	Send_zero1
;8
	call 	Send_zero1
;9
	call 	Send_zero1
;10
	call 	Send_zero1
;11
	movlw	0x0f
	movwf 	HD
	movlw 	0xf0
	movwf 	LD
	call	Send1

;12
	movlw	0x0e
	movwf 	HD
	movlw 	0x1c
	movwf 	LD
	call	Send1
;13
	movlw	0x38
	movwf 	HD
	movlw 	0x0c
	movwf 	LD
	call	Send1
;14
	movlw	0x30
	movwf 	HD
	movlw 	0x0c
	movwf 	LD
	call	Send1
;15
	movlw	0x70
	movwf 	HD
	movlw 	0x02
	movwf 	LD
	call	Send1
;16
    movlw	0x70
	movwf 	HD
	movlw 	0x62
	movwf 	LD
	call	Send1
;17
	movlw	0xf0
	movwf 	HD
	movlw 	0x73
	movwf 	LD
	call	Send1
;18
	movlw	0xfe
	movwf 	HD
	movlw 	0x73
	movwf 	LD
	call	Send1
;19
	movlw	0x8e
	movwf 	HD
	movlw 	0x71
	movwf 	LD
	call	Send1
;20
	movlw	0x06
	movwf 	HD
	movlw 	0x0f
	movwf 	LD
	call	Send1
;21
	movlw	0x3e
	movwf 	HD
	movlw 	0x02
	movwf 	LD
	call	Send1
;22
	movlw	0x87
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;23
	movlw	0x3e
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;24
	movlw	0x71
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send1
;25
	movlw	0x71
	movwf 	HD
	movlw 	0xe0
	movwf 	LD
	call	Send1
;26
	movlw	0x3f
	movwf 	HD
	movlw 	0x7f
	movwf 	LD
	call	Send1
;27
	movlw	0x3e
	movwf 	HD
	movlw 	0x7f
	movwf 	LD
	call	Send1
;28
    movlw	0x0e
	movwf 	HD
	movlw 	0x7c
	movwf 	LD
	call	Send1
;29
    movlw	0x0e
	movwf 	HD
	movlw 	0xe0
	movwf 	LD
	call	Send1
;30
	movlw	0x0e
	movwf 	HD
	movlw 	0xe0
	movwf 	LD
	call	Send1
;31
	movlw	0x08
	movwf 	HD
	movlw 	0x60
	movwf 	LD
	call	Send1
;32
	movlw	0xf0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
	
call      Set_address1

;New_Column    --8--

;1	
	call 	Send_zero1

;2	
	call 	Send_zero1

;3
	call 	Send_zero1
;4
	call 	Send_zero1
;5
	call 	Send_zero1
;6
	call 	Send_zero1
;7
	call 	Send_zero1
;8
	call 	Send_zero1
;9
	call 	Send_zero1
;10
	call 	Send_zero1
;11
	call 	Send_zero1

;12
	call 	Send_zero1
;13
	call 	Send_zero1
;14
	call 	Send_zero1
;15
	movlw	0x80
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;16
   call 	Send_zero1
;17
	movlw	0x80
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;18
	movlw	0x80
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;19
	movlw	0xc0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;20
	movlw	0xe0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;21
	movlw	0x3c
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;22
	movlw	0x1f
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;23
	movlw	0x07
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;24
	movlw	0x03
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send1
;25
	movlw	0x03
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send1
;26
	movlw	0x38
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send1
;27
	movlw	0xe3
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send1
;28
    movlw	0x03
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send1
;29
    movlw	0x03
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send1
;30
	movlw	0x03
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;31
	movlw	0x03
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;32
	movlw	0x07
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
	
call      Set_address1



;New_Column    --9--

	call	    ZERO2
	
	call      	Set_address1



;New_Column    --10--


	call	   ZERO2
	
	call      	Set_address1


;New_Column    --11--

call	ZERO2
	
	
call      	Set_address1



;New_Column    --12--


;1	
	movlw	0x00
	movwf 	HD
	movlw 	0x20
	movwf 	LD
	call	Send1

;2	
	movlw	0x00
	movwf 	HD
	movlw 	0x20
	movwf 	LD
	call	Send1

;3
	movlw	0x00
	movwf 	HD
	movlw 	0x20
	movwf 	LD
	call	Send1
;4
	movlw	0x00
	movwf 	HD
	movlw 	0x20
	movwf 	LD
	call	Send1
;5
	movlw	0x00
	movwf 	HD
	movlw 	0x20
	movwf 	LD
	call	Send1
;6
	movlw	0x00
	movwf 	HD
	movlw 	0x30
	movwf 	LD
	call	Send1
;7
	movlw	0x00
	movwf 	HD
	movlw 	0x10
	movwf 	LD
	call	Send1
;8
	movlw	0x00
	movwf 	HD
	movlw 	0x1c
	movwf 	LD
	call	Send1
;9
	movlw	0x00
	movwf 	HD
	movlw 	0x1c
	movwf 	LD
	call	Send1
;10
	movlw	0x00
	movwf 	HD
	movlw 	0x0c
	movwf 	LD
	call	Send1
;11
	movlw	0x00
	movwf 	HD
	movlw 	0x0c
	movwf 	LD
	call	Send1

;12
	movlw	0x00
	movwf 	HD
	movlw 	0x02
	movwf 	LD
	call	Send1
;13
	movlw	0x00
	movwf 	HD
	movlw 	0x03
	movwf 	LD
	call	Send1
;14
	movlw	0x00
	movwf 	HD
	movlw 	0x01
	movwf 	LD
	call	Send1
;15
	movlw	0x00
	movwf 	HD
	movlw 	0x01
	movwf 	LD
	call	Send1
;16
    movlw	0x00
	movwf 	HD
	movlw 	0x01
	movwf 	LD
	call	Send1
;17
	call 	Send_zero1
;18
	movlw	0x00
	movwf 	HD
	movlw 	0x1c
	movwf 	LD
	call	Send1
;19
	call 	Send_zero1
;20
	call 	Send_zero1
;21
	call 	Send_zero1
;22
	call 	Send_zero1
;23
	call 	Send_zero1
;24
	call 	Send_zero1
;25
	call 	Send_zero1
;26
	call 	Send_zero1
;27
	call 	Send_zero1
;28
    call 	Send_zero1
;29
    call 	Send_zero1
;30
	call 	Send_zero1
;31
	call 	Send_zero1
;32
	call 	Send_zero1
	
call      Set_address1


;New_Column    --13--

;1	
	movlw	0x70
	movwf 	HD
	movlw 	0x07
	movwf 	LD
	call	Send1

;2	
	movlw	0x38
	movwf 	HD
	movlw 	0x07
	movwf 	LD
	call	Send1

;3
	movlw	0x0c
	movwf 	HD
	movlw 	0xf0
	movwf 	LD
	call	Send1
;4
	movlw	0x0f
	movwf 	HD
	movlw 	0xf5
	movwf 	LD
	call	Send1
;5
	call 	Send_zero1
;6
	movlw	0xc0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;7
	call 	Send_zero1
;8
	call 	Send_zero1
;9
	call 	Send_zero1
;10
	call 	Send_zero1
;11
	call 	Send_zero1

;12
	call 	Send_zero1
;13
	movlw	0x80
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;14
	movlw	0x80
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;15
	movlw	0x80
	movwf 	HD
	movlw 	0x01
	movwf 	LD
	call	Send1
;16
    movlw	0xc0
	movwf 	HD
	movlw 	0x0f
	movwf 	LD
	call	Send1
;17
	movlw	0x70
	movwf 	HD
	movlw 	0x0e
	movwf 	LD
	call	Send1
;18
	movlw	0x70
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;19
	movlw	0x70
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;20
	movlw	0x70
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;21
	movlw	0x30
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;22
	movlw	0x08
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;23
	call 	Send_zero1
;24
	call 	Send_zero1
;25
	call 	Send_zero1
;26
	call 	Send_zero1
;27
	call 	Send_zero1
;28
    call 	Send_zero1
;29
    call 	Send_zero1
;30
	call 	Send_zero1
;31
	call 	Send_zero1
;32
	call 	Send_zero1

	
	call      Set_address1

;New_Column    --14--

;1	
	movlw	0x00
	movwf 	HD
	movlw 	0x7f
	movwf 	LD
	call	Send1

;2	
	movlw	0x00
	movwf 	HD
	movlw 	0x40
	movwf 	LD
	call	Send1

;3
	movlw	0x00
	movwf 	HD
	movlw 	0x40
	movwf 	LD
	call	Send1
;4
	movlw	0xc3
	movwf 	HD
	movlw 	0xc0
	movwf 	LD
	call	Send1
;5
	movlw	0x10 
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;6
	movlw	0x10
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;7
	movlw	0x10
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;8
	movlw	0x10
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;9
	movlw	0x10
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;10
	movlw	0x1c
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;11
	call 	Send_zero1

;12
	call 	Send_zero1
;13
	movlw	0x00
	movwf 	HD
	movlw 	0x20
	movwf 	LD
	call	Send1
;14
	movlw	0x00
	movwf 	HD
	movlw 	20
	movwf 	LD
	call	Send1
;15
	movlw	0x1c
	movwf 	HD
	movlw 	0x20
	movwf 	LD
	call	Send1
;16
    movlw	0x0e
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;17
	movlw	0x03
	movwf 	HD
	movlw 	0xe0
	movwf 	LD
	call	Send1
;18
	call 	Send_zero1
;19
	call 	Send_zero1
;20
	call 	Send_zero1
;21
	call 	Send_zero1
;22
	call 	Send_zero1
;23
	call 	Send_zero1
;24
	call 	Send_zero1
;25
	call 	Send_zero1
;26
	call 	Send_zero1
;27
	call 	Send_zero1
;28
    call 	Send_zero1
;29
   call 	Send_zero1
;30
	call 	Send_zero1
;31
	call 	Send_zero1
;32
	call 	Send_zero1
	
call      Set_address1

;New_Column    --15--

;1	
	movlw	0x80
	movwf 	HD
	movlw 	0x70
	movwf 	LD
	call	Send1

;2	
	movlw	0x00
	movwf 	HD
	movlw 	0x70
	movwf 	LD
	call	Send1

;3
	movlw	0x00
	movwf 	HD
	movlw 	0x10
	movwf 	LD
	call	Send1
;4
	movlw	0x00
	movwf 	HD
	movlw 	0x1c
	movwf 	LD
	call	Send1
;5
	call 	Send_zero1
;6
	call 	Send_zero1
;7
	call 	Send_zero1
;8
	movlw	0x00
	movwf 	HD
	movlw 	0x01
	movwf 	LD
	call	Send1
;9
	movlw	0x00
	movwf 	HD
	movlw 	0x0e
	movwf 	LD
	call	Send1
;10
	movlw	0x00
	movwf 	HD
	movlw 	0x0c
	movwf 	LD
	call	Send1
;11
	movlw	0x00
	movwf 	HD
	movlw 	0x01
	movwf 	LD
	call	Send1

;12
	movlw	0x00
	movwf 	HD
	movlw 	0xe0
	movwf 	LD
	call	Send1
;13
	movlw	0x01
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;14
	movlw	0x06
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;15
	movlw	0x0e
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;16
    movlw	0x08
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;17
	movlw	0x08
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;18
	movlw	0x38
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;19
	movlw	0x30
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;20
	call 	Send_zero1
;21
	call 	Send_zero1
;22
	call 	Send_zero1
;23
	call 	Send_zero1
;24
	call 	Send_zero1
;25
	call 	Send_zero1
;26
	call 	Send_zero1
;27
	call 	Send_zero1
;28
    call 	Send_zero1
;29
    call 	Send_zero1
;30
	call 	Send_zero1
;31
	call 	Send_zero1
;32
	call 	Send_zero1
	
call      Set_address1


;New_Column    --16--

;1	
	movlw	0x07
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1

;2	
	movlw	0x07
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1

;3
	movlw	0x04
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;4
	movlw	0x1c
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;5
	movlw	0x18
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;6
	movlw	0x60
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;7
	movlw	0x40
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;8
	movlw	0xc0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send1
;9
	call 	Send_zero1
;10
	call 	Send_zero1
;11
	call 	Send_zero1

;12
	call 	Send_zero1
;13
	call 	Send_zero1
;14
	call 	Send_zero1
;15
	call 	Send_zero1
;16
    call 	Send_zero1
;17
	call 	Send_zero1
;18
	call 	Send_zero1
;19
	call 	Send_zero1
;20
	call 	Send_zero1
;21
	call 	Send_zero1
;22
	call 	Send_zero1
;23
	call 	Send_zero1
;24
	call 	Send_zero1
;25
	call 	Send_zero1
;26
	call 	Send_zero1
;27
	call 	Send_zero1
;28
    call 	Send_zero1
;29
    call 	Send_zero1
;30
	call 	Send_zero1
;31
	call 	Send_zero1
;32
	call 	Send_zero1
return  
;**************************************************************
;**********************************************************
Send_cmd1
		movwf 		PORTD		; send the data command 
		bcf			PORTB,RB1   ; Rs=0 select command register 
		
		bsf 		PORTB,RB3  	; set the enable 
		nop 
		bcf 		PORTB,RB3  	; clear the enable 
		
		bcf 		PORTB,RB2
		call		delay1
		
		return  
;-------------------------------------------------------------------
Send_char1
		movwf 		PORTD		; send the data command 
		bsf			PORTB,RB1   ; Rs=1 select data register 
		
		bsf 		PORTB,RB3  	; set the enable 
		nop 
		bcf 		PORTB,RB3  	; clear the enable 
		
		bcf 		PORTB,RB2	;write the data to the GLCD 
		call	    delay1
	
		return  
;--------------------------------------
delay1								;Delay by 500 micro 
	movlw	0x9F
	movwf	Time
X11	decfsz	Time,f
	goto	X11
	return
;-----------------------------------------------------------------
Initial_21 					 ;Graphic display Mode

	movlw 	0x30             ; 8-bit mode/extended=0  (function set)  
	call  	Send_cmd1
	movlw 	0x01             ;Display Clear
	call  	Send_cmd1
	movlw 	0x36	         ;Extended Function Set:RE=1: extended instruction set
	call  	Send_cmd1	
	movlw 	0x3E		     ;EXFUNCTION(DL=8BITS,RE=1,G=1)
	call  	Send_cmd1
return
;-----------------------------------------------------------------
Send1
	incf 	adress_y,1
	movf	adress_y,0
	call	Send_cmd1
	movf	adress_x,0
	call	Send_cmd1
	movf 	HD,0
	call	Send_char1
	movf	LD,0
	call	Send_char1 
return 
;-----------------------------------------------------------------------------------------------
Send_zero1
	incf 	adress_y,1
	movf	adress_y,0
	call	Send_cmd1
	movf	adress_x,0
	call	Send_cmd1
	movlw	0x00
	call	Send_char1
	movlw	0x00
	call	Send_char1 
return 
;--------------------------------------------------------------------------------------------------
 	Set_address1
	movlw	0x7F
	movwf 	adress_y
	incf 	adress_x,1
RETURN 

;--------------------------------------------------------------------------------------------------
ZERO2
call 	Send_zero1

;2	
call 	Send_zero1      

;3
call 	Send_zero1
;4
call 	Send_zero1
;5
call 	Send_zero1
;6
call 	Send_zero1
;7
call 	Send_zero1
;8
call 	Send_zero1
;9
call 	Send_zero1
;10
call 	Send_zero1
;11
call 	Send_zero1
;12
call 	Send_zero1
;13
call 	Send_zero1
;14
call 	Send_zero1
;15
call 	Send_zero1
;16
call 	Send_zero1
;17
call 	Send_zero1
;18
call 	Send_zero1
;19
call 	Send_zero1
;20
call 	Send_zero1
;21
call 	Send_zero1
;22
call 	Send_zero1
;23
call 	Send_zero1
;24
call 	Send_zero1
;25
call 	Send_zero1
;26
call 	Send_zero1
;27
call 	Send_zero1
;28
call 	Send_zero1
;29
call 	Send_zero1
;30
call 	Send_zero1
;31
call 	Send_zero1
;32
call 	Send_zero1
	return 

;********************************************************

LOVE_YOU_AHMAD
;New_Column    --1--

	movlw	0x7F
	movwf 	adress_y
	movlw	0x80
	movwf	adress_x	
	call	ZERO21
	
	call	Set_address11
;************************
;New_Column    --2--
	
	call	ZERO21
	
	call      Set_address11
;************************
;New_Column    --3--


;1	
call 	Send_zero11

;2	
call 	Send_zero11

;3
call 	Send_zero11
;4
call 	Send_zero11
;5
call 	Send_zero11
;6
call 	Send_zero11
;7
call 	Send_zero11
;8
call 	Send_zero11
;9
call 	Send_zero11
;10
call 	Send_zero11
;11
call 	Send_zero11
;12
call 	Send_zero11
;13
	movlw	0x03
	movwf 	HD
	movlw 	0xe0
	movwf 	LD
	call	Send11
;14
	movlw	0x0e
	movwf 	HD
	movlw 	0x30
	movwf 	LD
	call	Send11
;15
	movlw	0x0c
	movwf 	HD
	movlw 	0x18
	movwf 	LD
	call	Send11
;16
    movlw	0x06
	movwf 	HD
	movlw 	0x18
	movwf 	LD
	call	Send11
;17
	movlw	0x06
	movwf 	HD
	movlw 	0x0c
	movwf 	LD
	call	Send11
;18
	movlw	0x06
	movwf 	HD
	movlw 	0x0e
	movwf 	LD
	call	Send11
;19
	movlw	0x07
	movwf 	HD
	movlw 	0x06
	movwf 	LD
	call	Send11
;20
	movlw	0x07
	movwf 	HD
	movlw 	0x07
	movwf 	LD
	call	Send11
;21
	movlw	0x03
	movwf 	HD
	movlw 	0x03
	movwf 	LD
	call	Send11
;22
	movlw	0x03
	movwf 	HD
	movlw 	0x03
	movwf 	LD
	call	Send11
;23
	movlw	0x03
	movwf 	HD
	movlw 	0x81
	movwf 	LD
	call	Send11
;24
	movlw	0x03
	movwf 	HD
	movlw 	0x81
	movwf 	LD
	call	Send11
;25
	movlw	0x03
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send11
;26
	movlw	0x01
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send11
;27
	movlw	0x01
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send11
;28
    movlw	0x01
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send11
;29
    movlw	0x01
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send11
;30
	movlw	0x01
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send11
;31
	movlw	0x01
	movwf 	HD
	movlw 	0xc0
	movwf 	LD
	call	Send11
;32
	movlw	0x01
	movwf 	HD
	movlw 	0xc0
	movwf 	LD
	call	Send11
	
	call      Set_address11
;************************
;New_Column    --4--

;1	
call 	Send_zero11

;2	
call 	Send_zero11      

;3
call 	Send_zero11
;4
call 	Send_zero11
;5
call 	Send_zero11
;6
call 	Send_zero11
;7
call 	Send_zero11
;8
call 	Send_zero11
;9
call 	Send_zero11
;10
call 	Send_zero11
;11
call 	Send_zero11
;12
call 	Send_zero11
;13
call 	Send_zero11
;14
call 	Send_zero11
;15
call 	Send_zero11
;16
call 	Send_zero11
;17
call 	Send_zero11
;18
call 	Send_zero11
;19
	movlw	0x00
	movwf 	HD
	movlw 	0x3f
	movwf 	LD
	call	Send11
;20
	movlw	0x00
	movwf 	HD
	movlw 	0xf0
	movwf 	LD
	call	Send11
;21
	movlw	0xbf
	movwf 	HD
	movlw 	0xc0
	movwf 	LD
	call	Send11
;22
	movlw	0xe1
	movwf 	HD
	movlw 	0xe0
	movwf 	LD
	call	Send11
;23
	movlw	0xc0
	movwf 	HD
	movlw 	0xe0
	movwf 	LD
	call	Send11
;24
	movlw	0xc0
	movwf 	HD
	movlw 	0xe0
	movwf 	LD
	call	Send11
;25
	movlw	0xc0
	movwf 	HD
	movlw 	0xe0
	movwf 	LD
	call	Send11
;26
	movlw	0xe0
	movwf 	HD
	movlw 	0x60
	movwf 	LD
	call	Send11
;27
	movlw	0x70
	movwf 	HD
	movlw 	0x70
	movwf 	LD
	call	Send11
;28
    movlw	0x70
	movwf 	HD
	movlw 	0x70
	movwf 	LD
	call	Send11
;29
    movlw	0x38
	movwf 	HD
	movlw 	0x30
	movwf 	LD
	call	Send11
;30
	movlw	0x18
	movwf 	HD
	movlw 	0x38
	movwf 	LD
	call	Send11
;31
	movlw	0x1f
	movwf 	HD
	movlw 	0xff
	movwf 	LD
	call	Send11
;32
	movlw	0x07
	movwf 	HD
	movlw 	0xc0
	movwf 	LD
	call	Send11
	
	call      Set_address11
;************************
;New_Column    --5--

;1	
call 	Send_zero11

;2	
call 	Send_zero11      

;3
call 	Send_zero11
;4
call 	Send_zero11
;5
call 	Send_zero11
;6
	movlw	0x0f
	movwf 	HD
	movlw 	0xf8
	movwf 	LD
	call	Send11
;7
	movlw	0x1c
	movwf 	HD
	movlw 	0x1c
	movwf 	LD
	call	Send11
;8
	movlw	0x18
	movwf 	HD
	movlw 	0x0e
	movwf 	LD
	call	Send11
;9
	movlw	0x18
	movwf 	HD
	movlw 	0x0e
	movwf 	LD
	call	Send11
;10
	movlw	0x18
	movwf 	HD
	movlw 	0x0e
	movwf 	LD
	call	Send11
;11
	movlw	0x18
	movwf 	HD
	movlw 	0x0e
	movwf 	LD
	call	Send11
;12
	movlw	0x18
	movwf 	HD
	movlw 	0x0e
	movwf 	LD
	call	Send11
;13
	movlw	0x38
	movwf 	HD
	movlw 	0x0c
	movwf 	LD
	call	Send11
;14
	movlw	0x38
	movwf 	HD
	movlw 	0x0c
	movwf 	LD
	call	Send11
;15
	movlw	0x38
	movwf 	HD
	movlw 	0x0c
	movwf 	LD
	call	Send11
;16
 	movlw	0x38
	movwf 	HD
	movlw 	0x0c
	movwf 	LD
	call	Send11
;17
	movlw	0x38
	movwf 	HD
	movlw 	0x0c
	movwf 	LD
	call	Send11
;18
	movlw	0x30
	movwf 	HD
	movlw 	0x0c
	movwf 	LD
	call	Send11
;19
	movlw	0xf0
	movwf 	HD
	movlw 	0x0c
	movwf 	LD
	call	Send11
;20
	movlw	0xf0
	movwf 	HD
	movlw 	0x1c
	movwf 	LD
	call	Send11
;21
	movlw	0x70
	movwf 	HD
	movlw 	0x1c
	movwf 	LD
	call	Send11
;22
	movlw	0x70
	movwf 	HD
	movlw 	0x1c
	movwf 	LD
	call	Send11
;23
	movlw	0x70
	movwf 	HD
	movlw 	0x1c
	movwf 	LD
	call	Send11
;24
	movlw	0x70
	movwf 	HD
	movlw 	0x0c
	movwf 	LD
	call	Send11
;25
	movlw	0x70
	movwf 	HD
	movlw 	0x0e
	movwf 	LD
	call	Send11
;26
	movlw	0x70
	movwf 	HD
	movlw 	0x07
	movwf 	LD
	call	Send11
;27
	movlw	0x70
	movwf 	HD
	movlw 	0x03
	movwf 	LD
	call	Send11
;28
	movlw	0x70
	movwf 	HD
	movlw 	0x03
	movwf 	LD
	call	Send11
;29
 	movlw	0x70
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send11
;30
	movlw	0x70
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send11
;31
	movlw	0xc0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send11
;32
	movlw	0x00
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send11
	
	call      Set_address11
;************************
;New_Column    --6--


;1	
call 	Send_zero11

;2	
call 	Send_zero11
;3
call 	Send_zero11
;4
call 	Send_zero11
;5
call 	Send_zero11
;6
call 	Send_zero11
;7
call 	Send_zero11
;8
call 	Send_zero11
;9
call 	Send_zero11
;10
call 	Send_zero11
;11
call 	Send_zero11
;12
call 	Send_zero11
;13
call 	Send_zero11
;14
call 	Send_zero11
;15
call 	Send_zero11
;16
call 	Send_zero11
;17
call 	Send_zero11
;18
call 	Send_zero11
;19
call 	Send_zero11
;20
call 	Send_zero11
;21
call 	Send_zero11
;22
call 	Send_zero11
;23
call 	Send_zero11
;24
call 	Send_zero11
;25
call 	Send_zero11
;26
call 	Send_zero11
;27
	movlw	0x00
	movwf 	HD
	movlw 	0x0f
	movwf 	LD
	call	Send11
;28
    movlw	0xff
	movwf 	HD
	movlw 	0xff
	movwf 	LD
	call	Send11
;29
    movlw	0x7e
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send11
;30
	movlw	0x00
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send11
;31
	movlw	0x00
	movwf 	HD
	movlw 	0x07
	movwf 	LD
	call	Send11
;32
	movlw	0x00
	movwf 	HD
	movlw 	0xf7
	movwf 	LD
	call	Send11
	
	call      Set_address11
;************************
;New_Column    --7--

;1	
call 	Send_zero11

;2	
call 	Send_zero11       

;3
call 	Send_zero11
;4
call 	Send_zero11
;5
call 	Send_zero11
;6
call 	Send_zero11
;7
call 	Send_zero11
;8
call 	Send_zero11
;9
call 	Send_zero11
;10
call 	Send_zero11
;11
call 	Send_zero11
;12
call 	Send_zero11
;13
call 	Send_zero11
;14
call 	Send_zero11
;15
call 	Send_zero11
;16
call 	Send_zero11
;17
call 	Send_zero11
;18
call 	Send_zero11
;19
call 	Send_zero11
;20
call 	Send_zero11
;21
call 	Send_zero11
;22
call 	Send_zero11
;23
call 	Send_zero11
;24
call 	Send_zero11
;25
call 	Send_zero11
;26
call 	Send_zero11
;27
	movlw	0xe0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send11
;28
    movlw	0xfc
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send11
;29
    movlw	0x07
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send11
;30
	movlw	0x07
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send11
;31
	movlw	0xfe
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send11
;32
	movlw	0x00
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send11
	
	call      Set_address11
;************************
;New_Column    --8--

	call	ZERO21
	
	call      Set_address11
;************************
;New_Column    --9--
	call	ZERO21
	
	call      Set_address11
;************************

;New_Column    --10--

;1	
call 	Send_zero11

;2	
call 	Send_zero11       

;3
call 	Send_zero11
;4
call 	Send_zero11
;5
call 	Send_zero11
;6
call 	Send_zero11
;7
call 	Send_zero11
;8
call 	Send_zero11
;9
call 	Send_zero11
;10
call 	Send_zero11
;11
call 	Send_zero11
;12
call 	Send_zero11
;13
call 	Send_zero11
;14
call 	Send_zero11
;15
call 	Send_zero11
;16
call 	Send_zero11
;17
call 	Send_zero11
;18
call 	Send_zero11
;19
call 	Send_zero11
;20
call 	Send_zero11
;21
call 	Send_zero11
;22
	movlw	0x00
	movwf 	HD
	movlw 	0x03
	movwf 	LD
	call	Send11

;23
	movlw	0x00
	movwf 	HD
	movlw 	0x1f
	movwf 	LD
	call	Send11

;24
	movlw	0x00
	movwf 	HD
	movlw 	0x3c
	movwf 	LD
	call	Send11

;25
	movlw	0x00
	movwf 	HD
	movlw 	0x3c
	movwf 	LD
	call	Send11

;26
	movlw	0x00
	movwf 	HD
	movlw 	0x1f
	movwf 	LD
	call	Send11

;27
	movlw	0x00
	movwf 	HD
	movlw 	0x03
	movwf 	LD
	call	Send11

;28
call 	Send_zero11
;29
call 	Send_zero11
;30
call 	Send_zero11
;31
call 	Send_zero11
;32
call 	Send_zero11
	
	call      Set_address11
;************************
;New_Column    --11--

;1	
	movlw	0x01
	movwf 	HD
	movlw 	0xc0
	movwf 	LD
	call	Send11

;2	
	movlw	0x01
	movwf 	HD
	movlw 	0xc0
	movwf 	LD
	call	Send11


;3
	movlw	0x00
	movwf 	HD
	movlw 	0xc0
	movwf 	LD
	call	Send11

;4
	movlw	0x00
	movwf 	HD
	movlw 	0xe0
	movwf 	LD
	call	Send11

;5
	movlw	0x00
	movwf 	HD
	movlw 	0xe0
	movwf 	LD
	call	Send11

;6
	movlw	0x00
	movwf 	HD
	movlw 	0x70
	movwf 	LD
	call	Send11

;7
	movlw	0x00
	movwf 	HD
	movlw 	0x30
	movwf 	LD
	call	Send11

;8
	movlw	0x00
	movwf 	HD
	movlw 	0x3c
	movwf 	LD
	call	Send11

;9
	movlw	0x00
	movwf 	HD
	movlw 	0x0f
	movwf 	LD
	call	Send11

;10
	movlw	0x00
	movwf 	HD
	movlw 	0x03
	movwf 	LD
	call	Send11

;11
call 	Send_zero11
;12
call 	Send_zero11
;13
call 	Send_zero11
;14
call 	Send_zero11
;15
call 	Send_zero11
;16
call 	Send_zero11
;17
call 	Send_zero11
;18
call 	Send_zero11
;19
call 	Send_zero11
;20
	movlw	0x00
	movwf 	HD
	movlw 	0x07
	movwf 	LD
	call	Send11

;21
	movlw	0x0f
	movwf 	HD
	movlw 	0x87
	movwf 	LD
	call	Send11

;22
	movlw	0x0c
	movwf 	HD
	movlw 	0x0f
	movwf 	LD
	call	Send11

;23
	movlw	0x3f
	movwf 	HD
	movlw 	0xc7
	movwf 	LD
	call	Send11

;24
	movlw	0x00
	movwf 	HD
	movlw 	0x0f
	movwf 	LD
	call	Send11

;25
	movlw	0x00
	movwf 	HD
	movlw 	0x07
	movwf 	LD
	call	Send11

;26
	movlw	0xff
	movwf 	HD
	movlw 	0xff
	movwf 	LD
	call	Send11

;27
	movlw	0xff
	movwf 	HD
	movlw 	0xff
	movwf 	LD
	call	Send11

;28
call 	Send_zero11
;29
call 	Send_zero11
;30
call 	Send_zero11
;31
call 	Send_zero11
;32
call 	Send_zero11
	
	call      Set_address11

;************************
;New_Column    --12--


;1	
call 	Send_zero11

;2	
call 	Send_zero11      

;3
call 	Send_zero11
;4
call 	Send_zero11
;5
call 	Send_zero11
;6
call 	Send_zero11
;7
call 	Send_zero11
;8
call 	Send_zero11
;9
	movlw	0x80
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send11

;10
	movlw	0xff
	movwf 	HD
	movlw 	0xff
	movwf 	LD
	call	Send11

;11	movlw	0x1f
	movwf 	HD
	movlw 	0xf8
	movwf 	LD
	call	Send11

;12
call 	Send_zero11
;13
call 	Send_zero11
;14
call 	Send_zero11
;15
call 	Send_zero11
;16
call 	Send_zero11
;17
call 	Send_zero11
;18
call 	Send_zero11
;19
call 	Send_zero11
;20
call 	Send_zero11
;21
call 	Send_zero11
;22
	movlw	0x03
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send11

;23
	movlw	0x03
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send11


;24
	movlw	0x03
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send11


;25
	movlw	0x03
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send11


;26
	movlw	0xff
	movwf 	HD
	movlw 	0xff
	movwf 	LD
	call	Send11

;27
	movlw	0xff
	movwf 	HD
	movlw 	0xff
	movwf 	LD
	call	Send11

;28
call 	Send_zero11
;29
call 	Send_zero11
;30
	movlw	0x03
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send11
;31
call 	Send_zero11
;32
call 	Send_zero11
	
	call      Set_address11
;************************
;New_Column    --13--


;1	
call 	Send_zero11

;2	
call 	Send_zero11       

;3
	movlw	0x00
	movwf 	HD
	movlw 	0x01
	movwf 	LD
	call	Send11

;4	movlw	0x00
	movwf 	HD
	movlw 	0x0f
	movwf 	LD
	call	Send11

;5
	movlw	0x00
	movwf 	HD
	movlw 	0x3c
	movwf 	LD
	call	Send11

;6
	movlw	0x01
	movwf 	HD
	movlw 	0xe0
	movwf 	LD
	call	Send11

;7
	movlw	0x07
	movwf 	HD
	movlw 	0x80
	movwf 	LD
	call	Send11

;8
	movlw	0x1e
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send11

;9
	movlw	0xf8
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send11

;10
	movlw	0xc0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send11

;11
call 	Send_zero11
;12
call 	Send_zero11
;13
call 	Send_zero11
;14
call 	Send_zero11
;15
call 	Send_zero11
;16
call 	Send_zero11
;17
call 	Send_zero11
;18
call 	Send_zero11
;19
call 	Send_zero11
;20
call 	Send_zero11
;21
call 	Send_zero11
;22
	movlw	0xff
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send11

;23
	movlw	0xe3
	movwf 	HD
	movlw 	0xe0
	movwf 	LD
	call	Send11

;24
	movlw	0x00
	movwf 	HD
	movlw 	0x70
	movwf 	LD
	call	Send11

;25
	movlw	0x00
	movwf 	HD
	movlw 	0x38
	movwf 	LD
	call	Send11

;26
	movlw	0xff
	movwf 	HD
	movlw 	0xfc
	movwf 	LD
	call	Send11

;27
	movlw	0xff
	movwf 	HD
	movlw 	0xf8
	movwf 	LD
	call	Send11

;28
call 	Send_zero11
;29
call 	Send_zero11
;30
call 	Send_zero11
;31
call 	Send_zero11
;32
call 	Send_zero11
	
	call      Set_address11
;************************
;New_Column    --14--


;1	
	movlw	0x07
	movwf 	HD
	movlw 	0xc0
	movwf 	LD
	call	Send11


;2	
	movlw	0x7e
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send11
    

;3
	movlw	0xe0
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send11

;4
call 	Send_zero11
;5
call 	Send_zero11
;6
call 	Send_zero11
;7
call 	Send_zero11
;8
call 	Send_zero11
;9
call 	Send_zero11
;10
call 	Send_zero11
;11
call 	Send_zero11
;12
call 	Send_zero11
;13
call 	Send_zero11
;141
call 	Send_zero11
;15
call 	Send_zero11
;16
	movlw	0x3c
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send11

;17
	movlw	0x0e
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send11

;18
	movlw	0xf8
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send11

;19
call 	Send_zero11
;20
	movlw	0x70
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send11

;21
	movlw	0x70
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send11
;22
	movlw	0x70
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send11
;23
	movlw	0x70
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send11
;24
	movlw	0x70
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send11
;25
	movlw	0x70
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send11
;26
	movlw	0x70
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send11
;27
	movlw	0x70
	movwf 	HD
	movlw 	0x00
	movwf 	LD
	call	Send11
;28
call 	Send_zero11
;29
call 	Send_zero11
;30
call 	Send_zero11
;31
call 	Send_zero11
;32
call 	Send_zero11
	call      Set_address11
;************************
;New_Column    --15--
	call	ZERO21
	call      Set_address11
;************************
;New_Column    --16--

	call	ZERO21
	
;************************
RETURN 
;_____________________________
Send_cmd11
		movwf 		PORTD		; send the data command 
		bcf			PORTB,RB1   ; Rs=0 select command register 
		
		bsf 		PORTB,RB3  	; set the enable 
		nop 
		bcf 		PORTB,RB3  	; clear the enable 
		
		bcf 		PORTB,RB2
		call		delay11
		
		return  
;-------------------------------------------------------------------
Send_char11
		movwf 		PORTD		; send the data command 
		bsf			PORTB,RB1   ; Rs=1 select data register 
		
		bsf 		PORTB,RB3  	; set the enable 
		nop 
		bcf 		PORTB,RB3  	; clear the enable 
		
		bcf 		PORTB,RB2	;write the data to the GLCD 
		call	    delay11
	
		return  
;--------------------------------------
delay11								;Delay by 500 micro 
	movlw	0x9F
	movwf	Time
X111	decfsz	Time,f
	goto	X111
	return
;-----------------------------------------------------------------
Initial_211 					 ;Graphic display Mode

	movlw 	0x30             ; 8-bit mode/extended=0  (function set)  
	call  	Send_cmd11
	movlw 	0x01             ;Display Clear
	call  	Send_cmd11
	movlw 	0x36	         ;Extended Function Set:RE=1: extended instruction set
	call  	Send_cmd11	
	movlw 	0x3E		     ;EXFUNCTION(DL=8BITS,RE=1,G=1)
	call  	Send_cmd11
return
;-----------------------------------------------------------------
Send11
	incf 	adress_y,1
	movf	adress_y,0
	call	Send_cmd11
	movf	adress_x,0
	call	Send_cmd11
	movf 	HD,0
	call	Send_char11
	movf	LD,0
	call	Send_char11 
return 
;-----------------------------------------------------------------------------------------------
Send_zero11
	incf 	adress_y,1
	movf	adress_y,0
	call	Send_cmd11
	movf	adress_x,0
	call	Send_cmd11
	movlw	0x00
	call	Send_char11
	movlw	0x00
	call	Send_char11
return 
;--------------------------------------------------------------------------------------------------
 	Set_address11
	movlw	0x7F
	movwf 	adress_y
	incf 	adress_x,1
RETURN 

;--------------------------------------------------------------------------------------------------
ZERO21
call 	Send_zero11

;2	
call 	Send_zero11     

;3
call 	Send_zero11
;4
call 	Send_zero11
;5
call 	Send_zero11
;6
call 	Send_zero11
;7
call 	Send_zero11
;81
call 	Send_zero11
;9
call 	Send_zero11
;10
call 	Send_zero11
;11
call 	Send_zero11
;12
call 	Send_zero11
;13
call 	Send_zero11
;14
call 	Send_zero11
;15
call 	Send_zero11
;16
call 	Send_zero11
;17
call 	Send_zero11
;18
call 	Send_zero11
;19
call 	Send_zero11
;20
call 	Send_zero11
;2
call 	Send_zero11
;22
call 	Send_zero11
;23
call 	Send_zero11
;24
call 	Send_zero11
;25
call 	Send_zero11
;26
call 	Send_zero11
;271
call 	Send_zero11
;28
call 	Send_zero11
;29
call 	Send_zero11
;30
call 	Send_zero11
;31
call 	Send_zero11
;32
call 	Send_zero11
	return 
;_______________________________
END 















	
	