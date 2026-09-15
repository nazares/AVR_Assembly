#define __SFR_OFFSET 0
#include <avr/io.h>

#define temp R16
#define sys R17

.section .text

.global main
.global __vector_14

main:
    ldi temp, hi8(RAMEND)
    out SPH, temp
    ldi temp, lo8(RAMEND)
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

__vector_14:
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
