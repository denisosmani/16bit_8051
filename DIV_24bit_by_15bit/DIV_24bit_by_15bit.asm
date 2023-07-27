;First number: [MSB R0, R1, LSB R2]
;Second number: [MSB R3, LSB R4]
;The result is stored in: [MSB R0, R1, LSB R2]
;Remainder isn't stored

;This code doesn't work for a 16bit divisor because,
;there are corner cases that don't fulfill the conditions
;The divisor can be up to 15 bits, but not greater than 15 bits

;This subroutine includes SUB_16BIT, CMP_16BIT, ADD_16BIT subroutines
;that you can check in other files
;this subroutine uses only the registers of Bank0
ORG 0000H

;first number
MOV R0,#36H  ;3589000 D
MOV R1,#0C3H
MOV R2,#88H

;second number (divisor)
MOV R3,#64H ;25689 D
MOV R4,#59H

LCALL DIV_24BIT_BY_15BIT ;result after calling 5 79 F4
;LCALL DIV_24BIT_BY_15BIT
;when calling another time, the subroutine always divides R0R1R2 with the same divisor
SJMP $



;----------------DIV_24bit_by_15bit_subroutine---------------------
DIV_24BIT_BY_15BIT:
MOV R7,#00H
MOV R6,#00H
MOV R5,#25D
TRY_TO_DIVIDE_AGAIN:
LCALL ROTATE_24BITS
PUSH 00H; store registers that CMP uses
PUSH 01H
PUSH 02H
PUSH 03H
MOV 00H,R6 ;first number for CMP
MOV 01H,R7
MOV 02H,R3 ;second number for CMP, divisor
MOV 03H,R4
LCALL CMP_16BIT ;compares the shifted part, with the divisor
JB ACC.0, DIVIDES
JB ACC.1, DIVIDES
JB ACC.2, CANT_DIVIDE ;if it can't divide, shifts again
DIVIDES:
PUSH 05H ;stores R5 because SUB subroutine changes it
PUSH 04H
LCALL SUB_16BIT ;if it can divide, subtracts and sets CY
;the result of SUB is stored in R6 and R7
SETB C
SJMP TRY_TO_SHIFT
CANT_DIVIDE:
CLR C
SJMP DONT_POP_R5
TRY_TO_SHIFT:
POP 04H
POP 05H
DONT_POP_R5:
POP 03H
POP 02H
POP 01H
POP 00H
DJNZ R5, TRY_TO_DIVIDE_AGAIN

RET

ROTATE_24BITS:
MOV A,R2
RLC A
MOV R2,A

MOV A,R1
RLC A
MOV R1,A

MOV A,R0
RLC A
MOV R0,A

MOV A,R7
RLC A
MOV R7,A

MOV A,R6
RLC A
MOV R6,A

RET
;----------------/DIV_24bit_by_15bit_subroutine---------------------

;----------------SUB_16bit_subroutine---------------------
;First number[MSB R0, LSB R1],
;Second number [MSB R2, LSB R3]
;The result is stored in R6, R7
SUB_16BIT:

LCALL SECOND_COMPLEMENT
LCALL ADD_16BIT
;this subroutine, subtracts two 16bit numbers
RET
;----------------/SUB_16bit_subroutine--------------------

;----------------SECOND_COMPLEMENT_subroutine--------------------
SECOND_COMPLEMENT:

MOV R4,#17D
FIRST_COMPLEMENT_16BITS:
MOV A,R2
RLC A
MOV R2,A

CPL C  ;complements the 2nd number

MOV A,R3
RLC A
MOV R3,A
DJNZ R4,FIRST_COMPLEMENT_16BITS

;second complement
MOV A,R3
ADD A,#1D ;+1 = second complement
MOV R3,A

MOV A,R2
ADDC A,#00H ;propagate carry if generated
MOV R2,A
;this subroutine complements bits of R2 and R3,
;and stores the result in the same registers
RET
;----------------/SECOND_COMPLEMENT_subroutine--------------------

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


;---------------CMP_16bit_subroutine--------------------

;First number [MSB R0, LSB R1]
;Second number [MSB R2, lSB R3]
;If First > Second // ACC.0 = 1, all other bits of A are cleared
;If First = Second // ACC.1 = 1, all other bits of A are cleared
;If First < Second // ACC.2 = 1, all other bits of A are cleared
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
;---------------/CMP_16bit_subroutine--------------------
END
