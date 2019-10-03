.global _Reset
_Reset:
 LDR sp, =stack_top
 ldr r0, =value
 ldr r1, =input
 BL c_entry
 B .
value: .word 0x2
input: .ascii "ala ma kota\n\0"
