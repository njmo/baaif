.data
.ALIGN 8
inp_struct:
.word 0x2
.ascii "ala ma srake\n\0"

.text
.global _Reset
_Reset:
 LDR sp, =stack_top
 ldr r0, =inp_struct
 BL c_entry
 B .

.globl UART_PUT32
UART_PUT32:
  ldr r1, =#0x101f1000
  str r0, [r1]
  bx lr
