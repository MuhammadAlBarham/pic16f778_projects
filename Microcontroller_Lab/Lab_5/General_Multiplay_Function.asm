#include<p16f84a.inc>
cblock 0x1c
Input1
Input2
temp
Result
endc 
clrf  Result
movf  Input1,1
btfsc STATUS,2
goto  finish 
movf  Input2,1
btfsc STATUS,2 
goto  finish
  
Again 
movf Input2,0 
addwf  Result,1
decfsz Input1,1
goto Again

finish 

nop 
end 



