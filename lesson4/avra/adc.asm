.include "m16def.inc"
.def temp = R16
.def dc1 = R17
.def dc2 = R18

.dseg
.cseg
.org 0
    jmp reset
.org $01C
    jmp ADC_Conv ; ADC Conversion Complete Handler

reset:
    ldi temp, high(RAMEND)
    out SPH, temp
    ldi temp, low(RAMEND)
    out SPL, temp

    ldi temp, 0xff
    out DDRD, temp

    ldi temp, 0x60
    out ADMUX, temp
    ldi temp, 0xdf
    out ADCSRA, temp

    sei

main:
    rjmp main

ADC_Conv:
    cli
    in dc1, ADCL
    in dc2, ADCH
    out PORTD, dc2

vix:
    ldi temp, 0x60
    out ADMUX, temp
    ldi temp, 0xDF
    out ADCSRA, temp
    sei
    reti