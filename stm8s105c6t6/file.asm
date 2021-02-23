CLK_SWR           = (0x50C4)        ; Clock master switch register
CLK_SWCR          = (0x50C5)       ; Clock switch control register
CLK_CKDIVR        = (0x50C6)       ; Clock divider register
PD_ODR            = (0x500F)       ; Port D data output latch register
PD_DDR            = (0x5011)       ; Port D data direction register

UART2_SR = (0x5240)
UART2_DR = (0x5241)
UART2_CR1  = (0x5244)
UART2_CR2  = (0x5245)
UART2_CR3  = (0x5246)
UART2_BBR1 = (0x5242)
UART2_BBR2 = (0x5243)

TIM2_CR1 = (0x5300)
TIM2_SR1 = (0x5302)
TIM2_IER = (0x5301)
TIM2_ARRH = (0x530D)
TIM2_ARRL = (0x530E)
TIM2_PSCR = (0x530C)
TIM2_EGR = (0x5304)

.area DATA
ptr: .blkb 1

.area SSEG (ABS)
.org (0x600)
.ds 512

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     table des vecteurs d'interruption
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    .area HOME
    int main  ; vecteur de réinitialisation
 int NonHandledInterrupt ;TRAP  software interrupt
 int NonHandledInterrupt ;int0 TLI   external top level interrupt
 int NonHandledInterrupt ;int1 AWU   auto wake up from halt
 int NonHandledInterrupt ;int2 CLK   clock controller
 int NonHandledInterrupt ;int3 EXTI0 port A external interrupts
 int NonHandledInterrupt ;int4 EXTI1 port B external interrupts
 int NonHandledInterrupt ;int5 EXTI2 port C external interrupts
 int NonHandledInterrupt ;int6 EXTI3 port D external interrupts
 int NonHandledInterrupt ;int7 EXTI4 port E external interrupts
 int NonHandledInterrupt ;int8 beCAN RX interrupt
 int NonHandledInterrupt ;int9 beCAN TX/ER/SC interrupt
 int NonHandledInterrupt ;int10 SPI End of transfer
 int NonHandledInterrupt ;int11 TIM1 update/overflow/underflow/trigger/break
 int NonHandledInterrupt ;int12 TIM1 capture/compare
 int TimerInterrupt ;int13 TIM2 update /overflow
 int NonHandledInterrupt ;int14 TIM2 capture/compare
 int NonHandledInterrupt ;int15 TIM3 Update/overflow
 int NonHandledInterrupt ;int16 TIM3 Capture/compare
 int NonHandledInterrupt ;int17 UART1 TX completed
 int NonHandledInterrupt ;int18 UART1 RX full
 int NonHandledInterrupt ;int19 I2C
 int NonHandledInterrupt ;int20 UART3 TX completed
 int NonHandledInterrupt ;int21 UART3 RX full
 int NonHandledInterrupt ;int22 ADC2 end of conversion
 int NonHandledInterrupt ;int23 TIM4 update/overflow
 int NonHandledInterrupt ;int24 flash writing EOP/WR_PG_DIS
 int NonHandledInterrupt ;int25  not used
 int NonHandledInterrupt ;int26  not used
 int NonHandledInterrupt ;int27  not used
 int NonHandledInterrupt ;int28  not used

    .area CODE
main:
    mov CLK_CKDIVR,#0                    ; set max internal clock
    bset CLK_SWCR,#1                     ; enable external clcok (clock is 16mhz)
    mov CLK_SWR,#0xb4                      ; switch in external cyrstal clock

wait_hw_clock:
    btjf CLK_SWCR,#3,wait_hw_clock     ; wait swif
    bres CLK_SWCR,#3                   ; clear swif

    ldw X,#0x7ff
    ldw sp, x

    ldw x, #0

clear_ram:
    clr(x)
    incw x
    cpw x, #0x7ff
    jrule clear_ram

    bset  PD_DDR,#0        ; PD0 is set to output mode
    mov UART2_CR1,#0
    mov UART2_CR2,#0
    mov UART2_CR3,#0

    bset UART2_CR2, #3
    mov UART2_BBR2,#0x03
    mov UART2_BBR1,#0x68

    bset TIM2_IER,#0
    mov TIM2_PSCR,#8
    mov TIM2_ARRH,#0xF4
    mov TIM2_ARRL,#0x24

    bset TIM2_CR1, #0

    rim
$1: wfi
    jra $1

blink_once:
    bcpl  PD_ODR,#0
    ret
print_once:
   ldw x, #napis_len
   ldw y, #napis
next_char:
   ld a,(y)
   ld UART2_DR, a
loop:
   btjf UART2_SR,#6, loop
   incw y
   decw x
   jrne next_char
   ret

napis:
.ascii "Marcin to gej"
.byte 0xd, 0xa, 0
napis_len = (.-napis)

TimerInterrupt:
    call blink_once
    mov TIM2_SR1, #0
    call print_once
    iret

NonHandledInterrupt:
    iret
