;ADD 16bit numbers
;Parameters of the suroubtine: First number[MSB R0, LSB R1], Second number [MSB R2, LSB R3]
;The result is stored in R5, R6, R7, no need to clear these registers before calling the subroutine

;             R0 R1                 FF FF
;           + R2 R3               + FF FF
;          ----------           -------------
;          R5 R6 R7               1 FF FE

ORG 0000H

MOV R0,#0FFH ;first number
MOV R1,#0FFH

MOV R2,#0FFH ;second number
MOV R3,#0FFH

LCALL ADD_16BIT ;calling subroutine

SJMP $





;----------------ADD_16bit_subroutine--------------------
ADD_16BIT:
MOV A,R1 ;R1+R3
ADD A,R3 ;ADD instruction generates CY='1', if A+R3>255, if A+R3<255 generates CY='0', even if CY='1'
MOV R7,A ;

MOV A,R0  ;R0+R2
ADDC A,R2 ;
MOV R6,A  ;

JNB CY, NO_CARRY   ;check if carry after R0+R2
MOV R5,#01H        ;if CY='1'
SJMP END_ADD_16BIT
NO_CARRY:
MOV R5,#00H        ;if CY='0'
END_ADD_16BIT:
RET
;---------------/ADD_16bit_subroutine--------------------

END