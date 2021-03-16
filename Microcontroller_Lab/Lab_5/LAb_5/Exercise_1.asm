; ----------------------------------------------------------
; General Purpose RAM Assignments
; ----------------------------------------------------------
cblock 0x1c
InputM3
Input_TempM3
Input_TempM9
InputM9
ResultM3
Result_TempM3
Result_TempM9
ResultM9
Endc

;Macro Definitions
; ----------------------------------------------------------
Multiply3   macro
Movf  Input_TempM3  ,0
Addwf Result_TempM3 ,1
addwf Result_TempM3 ,1
addwf Result_TempM3 ,1
Endm
; ----------------------------------------------------------
; Vector definition
; ----------------------------------------------------------
org 0x000
nop
goto Main
INT_Routine org 0x004
goto INT_Routine
; ----------------------------------------------------------
; The main Program
; ----------------------------------------------------------
Main
movf InputM3,0
movwf Input_TempM3
movf InputM9,0
movwf Input_TempM9
Multiply3
movf  Result_TempM3,0
movwf  ResultM3
Call Multiply9
movf Result_TempM9,0
movwf ResultM9
Goto finish
; ----------------------------------------------------------
; Sub Routine Definitions
; ----------------------------------------------------------
Multiply9
movf InputM9,0 
movwf Input_TempM3
Multiply3
movf Result_TempM3,0
addwf Result_TempM9,1
Multiply3
movf Result_TempM3,0
addwf Result_TempM9,1
Multiply3
movf Result_TempM3,0
addwf Result_TempM9,1
Return

finish
nop
end