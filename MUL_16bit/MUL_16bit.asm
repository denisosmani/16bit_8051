;MUL_16bit subroutine
;All operations of this subroutine are done in Bank 0, registers R0 - R7
;First number: [MSB R0, LSB R1] and Second number: [MSB R2, lSB R3]
;The result is stored in [MSB R4, R5, R6, R7]

;             R0 R1                 FF FF
;           x R2 R3               x FF FF
;          ----------           -------------
;             R6 R7                 FE 01     ;R3xR1 ;  store R6 R7
;          R4 R5              +  FE 01        ;R3xR0 ;  store R4 R5
;          R1 R3                 FE 01        ;R2xR1 ;  store R1 R3
;       R0 R2                 FE 01           ;R2xR0 ;  store R0 R2
;   ------------------      ------------------
;       R4 R5 R6 R7           FF FE 00 01

ORG 0000H

MOV R0,#0FFH
MOV R1,#0FFH

MOV R2,#0FFH
MOV R3,#0FFH

LCALL MUL_16BIT

SJMP $

;------------MUL_16bit_subroutine------------
MUL_16BIT:
MOV A,R3  ;R3xR1
MOV B,R1
MUL AB    ; (B) <- HIGH // (A) <- LOW
MOV R6,B
MOV R7,A  ;store R6 R7

MOV A,R3  ;R3xR0
MOV B,R0
MUL AB    ; (B) <- HIGH // (A) <- LOW
MOV R4,B
MOV R5,A  ;store R4 R5

MOV A,R2  ;R2xR1
MOV B,R1
MUL AB    ; (B) <- HIGH // (A) <- LOW
MOV R1,B
MOV R3,A  ;store R1 R3

MOV A,R2  ;R2xR0
MOV B,R0
MUL AB    ; (B) <- HIGH // (A) <- LOW
MOV R0,B
MOV R2,A  ;store R0 R2

MOV A,R6 ; R6+R5
ADD A,R5
MOV R6,A ;store  result R6

MOV A,R4  ; R4+R1
ADDC A,R1 ;propagate carry
MOV R4,A  ;store result R4

MOV A,R0   ;R0 + C
ADDC A,#0D ;propagate carry
MOV R0,A   ;store result R0

MOV A,R3  ;R3+R6
ADD A,R6
MOV R6,A  ;store R6

MOV A,R4  ; R4+R2
ADDC A,R2 ;propagate carry
MOV R5,A  ;store result R4

MOV A,R0   ;R0 + C
ADDC A,#0D ;propagate carry
MOV R4,A   ;store result R4

RET
;-----------/MUL_16bit_subroutine------------

END