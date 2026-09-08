.include "m16def.inc"
.def temp = R16

.cseg
.org 0
    jmp reset
.org $002
    jmp EXT_INT0 ; IRQ0 Handler

reset:
    ldi temp, high(RAMEND)
    out SPH, temp
    ldi temp, low(RAMEND)
    out SPL, temp

    ldi temp, 0b01000000
    out GICR, temp
    ldi temp, 0b00000010
    out MCUCR, temp

    sei
main:
    rjmp main

EXT_INT0:
    cli
    sbis PORTB, 0
    rjmp L1

    cbi PORTB, 0

vix:
    sei
    reti
L1:
    sbi PORTB, 0
    rjmp vix