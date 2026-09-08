.include "m16def.inc"
.def temp = R16

.cseg
.org 0
    jmp reset
.org $020
    jmp ANA_COMP

reset:
    ldi temp, high(RAMEND)
    out SPH, temp
    ldi temp, low(RAMEND)
    out SPL,temp

    ldi temp, 0xFF
    out DDRD, temp

    ldi temp, 0b00011000
    out ACSR, temp
    
    sei
main:
    rjmp main

ANA_COMP:
    cli
    in temp, ACSR
    sbrs temp, 5
    rjmp L1
    ldi temp, 0xFF
    out PORTD, temp
vix:
    sei
    reti

L1:
    ldi temp, 0x00
    out PORTD, temp
    rjmp vix