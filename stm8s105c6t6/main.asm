stm8/
   
    #include "mapping.inc"    
   
   
CLK_SWR           EQU $50C4        ; Clock master switch register
CLK_SWCR          EQU $50C5        ; Clock switch control register
CLK_CKDIVR        EQU $50C6        ; Clock divider register
PD_ODR            EQU $500F        ; Port D data output latch register
PD_DDR            EQU $5011        ; Port D data direction register

UART2_SR	EQU $5240
UART2_DR	EQU $5241
UART2_CR1  EQU $5244
UART2_CR2  EQU $5245
UART2_CR3  EQU $5246
UART2_BBR1	EQU $5242
UART2_BBR2	EQU $5243


; UART_DIV=0x0693 
;BBR1=0x68h 
;BBR2=0x03
 
    segment 'rom'
start

    mov CLK_CKDIVR,#$0                    ; set max internal clock
    bset CLK_SWCR,#$1                     ; enable external clcok (clock is 16mhz)
    mov CLK_SWR,#$B4                      ; switch in external cyrstal clock
wait_hw_clock
    btjf CLK_SWCR,#$3,wait_hw_clock     ; wait swif
    bres CLK_SWCR,#$3                   ; clear swif
   
    ldw X,#$stack_segment_end     ; initialize SP
    ldw SP,X
   
    ldw X,#$ram0_segment_start  ; clear all the ram
clear_ram
    clr (X)
    incw X
    cpw X,#$stack_segment_end
    jrule clear_ram
; it is now safe to use the stack

; init our program
    bset  PD_DDR,#0        ; PD0 is set to output mode                    
		mov UART2_CR1,#0 
		mov UART2_CR2,#0 
		mov UART2_CR3,#0
		
		bset UART2_CR2, #3
		mov UART2_BBR2,#$03
		mov	UART2_BBR1,#$68
	
;ldf A,$5240
; main program loop
loop_forever                                    
    call blink_once
		call print_once
    jra loop_forever

; blink is now a subroutine
; this delays for about a second then toggles the
; LED On or Off
blink_once
    ldw X,#$FFFF    
loop_delay
    ldw Y,#$0050    
loop_inner_delay
    decw Y
    jrne loop_inner_delay
    decw X
    jrne loop_delay
    bcpl  PD_ODR,#0   
    ret
		
print_once
	  ldw X, #LEN_NAPIS
		ldw Y, #napis
		
next_char
		ld a,(Y)
		ld UART2_DR, a
loop
		btjf UART2_SR,#6, loop
		incw y
		decw x
		jrne next_char
		ret
		

napis: dc.b "Marcin to gej", $d, $a, 0
LEN_NAPIS	equ	{*-napis}

; the default interupt handler
    interrupt NonHandledInterrupt
NonHandledInterrupt
    iret

; the interupt table
    segment 'vectit'
    dc.l {$82000000+start}                                ; reset
    dc.l {$82000000+NonHandledInterrupt}    ; trap
    dc.l {$82000000+NonHandledInterrupt}    ; irq0 TLI External top level interupt
    dc.l {$82000000+NonHandledInterrupt}    ; irq1 AWU Auto wake up from halt
    dc.l {$82000000+NonHandledInterrupt}    ; irq2 CLK Clock Controller
    dc.l {$82000000+NonHandledInterrupt}    ; irq3 EXTIO Port A external
    dc.l {$82000000+NonHandledInterrupt}    ; irq4 EXTI1 Port B
    dc.l {$82000000+NonHandledInterrupt}    ; irq5 EXTI2 Port C
    dc.l {$82000000+NonHandledInterrupt}    ; irq6 EXTI3 Port D
    dc.l {$82000000+NonHandledInterrupt}    ; irq7 EXTI4 Port E external
    dc.l {$82000000+NonHandledInterrupt}    ; irq8  reserved
    dc.l {$82000000+NonHandledInterrupt}    ; irq9  reserved
    dc.l {$82000000+NonHandledInterrupt}    ; irq10 SPI end of transfer
    dc.l {$82000000+NonHandledInterrupt}    ; irq11 TIM1 Update/overflow/underflow/trigger/break
    dc.l {$82000000+NonHandledInterrupt}    ; irq12 TIM1 Capture/Compare
    dc.l {$82000000+NonHandledInterrupt}    ; irq13 TIM2 update/overflow
    dc.l {$82000000+NonHandledInterrupt}    ; irq14 TIM2 capture / compare
    dc.l {$82000000+NonHandledInterrupt}    ; irq15 TIM3 Update/ overflow
    dc.l {$82000000+NonHandledInterrupt}    ; irq16 TIM3 Capture / Compare
    dc.l {$82000000+NonHandledInterrupt}    ; irq17 reserved
    dc.l {$82000000+NonHandledInterrupt}    ; irq18 reserved
    dc.l {$82000000+NonHandledInterrupt}    ; irq19 I2C
    dc.l {$82000000+NonHandledInterrupt}    ; irq20 Uart2 Tx Complete
    dc.l {$82000000+NonHandledInterrupt}    ; irq21 Uart2 Recieve Register Data Full
    dc.l {$82000000+NonHandledInterrupt}    ; irq22 ADC1 end of conversion
    dc.l {$82000000+NonHandledInterrupt}    ; irq23 TIM4 Update/Overflow
    dc.l {$82000000+NonHandledInterrupt}    ; irq24 Flash EOP/WR_PG_DIS
    dc.l {$82000000+NonHandledInterrupt}    ; irq25 reserved
    dc.l {$82000000+NonHandledInterrupt}    ; irq26 reserved
    dc.l {$82000000+NonHandledInterrupt}    ; irq27 reserved
    dc.l {$82000000+NonHandledInterrupt}    ; irq28 reserved
    dc.l {$82000000+NonHandledInterrupt}    ; irq29 reserved

    end
    