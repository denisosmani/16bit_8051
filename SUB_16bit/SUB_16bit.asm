;SUB 16bit numbers
;Parameters of the suroubtine: First number[MSB R0, LSB R1], Second number [MSB R2, LSB R3]
;The result is stored in R6, R7, no need to clear these registers before calling the subroutine
;The SUB_16bit subroutine changes R5 when propagating the carry after the adding is done,
;but that's a don't care byte in this case
;The SUB_16bit subroutine includes the ADD_16bit subroutine, since the subtraction
;is done by 2's complement method

;   First:          R0 R1                 A9 87
;   Second:       - R2 R3               - 56 78
;                ----------            -----------
;   Result:         R6 R7                 53 0F

ORG 0000H

MOV R0,#0A9H ;first number
MOV R1,#87H

MOV R2,#56H ;second number
MOV R3,#78H

LCALL SUB_16BIT

SJMP $

;----------------SUB_16bit_subroutine---------------------
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

END
