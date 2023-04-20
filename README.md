#16bit_math_operations_8051

Implemented subroutines of addition, subtraction, multiplication, division and comparison of 16 bit numbers in a 8bit mcu.
All subroutines are implemented using only registers of BANK0.
So if you call one of these subroutines in your program and BANK0 registers
have a significance, meaning are used to store a value that must not be changed
then you can PUSH those registers in the STACK before calling the subroutine and then
POP after the subroutine has been executed.

