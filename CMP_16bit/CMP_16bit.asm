;CMP_16bit subroutine
;This subroutine compares two 16 bit numbers
;First number [MSB R0, LSB R1]
;Second number [MSB R2, lSB R3]
;If First > Second // ACC.0 = 1, all other bits of A are cleared
;If First = Second // ACC.1 = 1, all other bits of A are cleared
;if First < Second // ACC.2 = 1, all other bits of A are cleared

ORG 0000H
MOV R0,#02H ;first number
MOV R1,#02H

MOV R2,#02H ;second number
MOV R3,#02H

LCALL CMP_16BIT

SJMP $


;----------------CMP_16bit_subroutine---------------------
CMP_16BIT:
;compare MSBs
MOV A,R0 ;first_MSB
CJNE A, 02H, MSB_NOT_EQUAL ;compare with second_MSB
;if MSBs are equal then compare LSBs
MOV A,R1 ;first LBS
CJNE A, 03H, LSB_NOT_EQUAL ;compare with second_LSB
MOV A,#00H
SETB ACC.1
SJMP END_CMP_ROUTINE
LSB_NOT_EQUAL:
JB CY, FIRST_LESS_THAN_SECOND
SJMP FIRST_GREATER_THAN_SECOND
MSB_NOT_EQUAL:
JB CY, FIRST_LESS_THAN_SECOND ;(A)<direct C=1
FIRST_GREATER_THAN_SECOND:
MOV A,#00H
SETB ACC.0
SJMP END_CMP_ROUTINE
FIRST_LESS_THAN_SECOND:
MOV A,#00H
SETB ACC.2
END_CMP_ROUTINE:
RET
;----------------/CMP_16bit_subroutine---------------------

END
