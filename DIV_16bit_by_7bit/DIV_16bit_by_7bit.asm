;DIV_16BIT_BY_7BIT subroutine
;The 16bit number [MSB R0,  LSB R1] is divided by 7bit number [R2]
;The quotient is stored in [MSB R0, LSB R1]
;The remainder is stored R7
;This code doesn't work for a 8bit divisor because,
;there are corner cases that don't fulfill the conditions
;The divisor can be up to seven bits, but not greater than 7bits
;This subroutine uses only the Bank 0 registers
;The division is done using the long division method of binary numbers

;R0R1 / R2 = R0R1, remainder in R7

ORG 0000H

MOV R0,#0FH ; 0E03H = 3587D
MOV R1,#9FH ; 166H = 358D
	    ;remainder = 7
MOV R2,#0AH

LCALL DIV_16BIT_BY_7BIT

SJMP $






DIV_16BIT_BY_7BIT:
MOV R3,#17D ;rotate bits 17 times
TRY_TO_DIVIDE:
LCALL ROTATE_16BITS 
MOV A,R5
CJNE A,02H, NOT_EQUAL
MOV R5,#00H
SETB C
SJMP END_DIVISION
NOT_EQUAL:
JB CY, LESS_THAN_DIVISOR  ;(A) < direct CY = 1
CLR C
MOV A,R5
SUBB A,R2
MOV R5,A
SETB C
SJMP END_DIVISION
LESS_THAN_DIVISOR:
CLR C
END_DIVISION:
DJNZ R3,TRY_TO_DIVIDE
MOV R5,#00H
CLR C
RET


ROTATE_16BITS:
PUSH PSW ;store the CY
;must store the remainder before the last rotation of bits
;otherwise the remainder is lost
CJNE R3,#01D, DONT_STORE_REMAINDER ; while comparing delets the CY flag
MOV A,R5 ;store remainder
MOV R7,A
DONT_STORE_REMAINDER:

POP PSW ;pop the CY

MOV A,R1
RLC A
MOV R1,A

MOV A,R0
RLC A
MOV R0,A

MOV A,R5
RLC A
MOV R5,A

MOV A,R4
RLC A
MOV R4,A
RET

END