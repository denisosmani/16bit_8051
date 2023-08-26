# 16bit_math_operations_8051
16bit math operations for 8051

This project involves the implementation of subroutines for various 16-bit math operations, including addition, subtraction, multiplication, division, and comparison. These operations are executed on an 8-bit MCU.

All subroutines are meticulously crafted to function using registers located in BANK0. If the registers in BANK0 hold significance in your program — that is, if they store values that must remain unchanged — you can follow these steps:

1. **PUSH**: Before calling one of the math operation subroutines, push the relevant registers into the STACK to preserve their values.
2. **Execute Subroutine**: Call the desired subroutine for the math operation.
3. **POP**: After the subroutine execution, pop the registers from the STACK to restore their original values.

This approach ensures the integrity of your BANK0 registers throughout the subroutine execution.

Feel free to integrate these subroutines into your program, following the PUSH-EXECUTE-POP pattern.

Remember to customize the usage according to your project's requirements and MCU's capabilities.

<!-- If you have any code examples, images, or diagrams related to this, consider adding them to provide visual aid. -->

