# 16bit_math_operations_8051

This project involves the implementation of subroutines for various 16-bit math operations
- Addition
- Subtraction
- Multiplication
- Division
- Comparison

All subroutines use only the registers of BANK0. If the registers in BANK0 hold significance in your program — that is, if they store values that must remain unchanged — you can follow these steps:

1. **PUSH**: Before calling one of the math operation subroutines, push the relevant registers into the STACK to preserve their values.
2. **Execute Subroutine**: Call the desired subroutine for the math operation.
3. **POP**: After the subroutine execution, pop the registers from the STACK to restore their original values.

This approach ensures the integrity of your BANK0 registers throughout the subroutine execution.



