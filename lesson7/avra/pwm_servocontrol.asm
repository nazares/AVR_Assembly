.include "m16def.inc"
.def temp = R16
.def sys = R17

.cseg
.org 0
    jmp reset
.org $01C
    jmp ADC_CONV ; ADC Conversion Complete Handler

reset:
    ldi temp, high(RAMEND)
    out SPH, temp
    ldi temp, low(RAMEND)
    out SPL, temp

    ldi temp, 0xFF
    out DDRD, temp
    out DDRB, temp

    ldi temp, 0b01100011
    out TCCR0, temp
    ldi temp, 0b01100100
    out TCCR2, temp

    out OCR0, temp
    out OCR2, temp

    ldi temp, 0b01100001
    out ADMUX, temp
    ldi temp, 0b11011110
    out ADCSRA, temp
    ldi sys, 0
    sei

loop:
    rjmp loop

ADC_CONV:
    cli
    cpi sys, 0
    breq ADC_CONV0
    cpi sys, 1
    breq ADC_CONV1
vix:
    sei
    reti
ADC_CONV0:
    in temp, ADCL
    in sys, ADCH
    out OCR0, sys
    ldi temp, 0b01100000
    out ADMUX, temp
    ldi temp, 0b11011110
    out ADCSRA, temp
    ldi sys, 1
    rjmp vix

ADC_CONV1:
    in temp, ADCL
    in sys, ADCH
    out OCR2, sys
    ldi temp, 0b01100001
    out ADMUX, temp
    ldi temp, 0b11011110
    out ADCSRA, temp
    ldi sys, 0
    rjmp vix
