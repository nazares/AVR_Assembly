#define __SFR_OFFSET 0
#include <avr/io.h>

#define temp R16
#define dc1 R17
#define dc2 R18

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

    ldi temp, 0x60
    out ADMUX, temp
    ldi temp, 0xDF
    out ADCSRA, temp

    sei
loop:
    rjmp loop

__vector_14:
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