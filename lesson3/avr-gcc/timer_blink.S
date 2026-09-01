#define __SFR_OFFSET 0
#include <avr/io.h>
#include <avr/interrupt.h>

#define temp R16
#define sys R17

.section .text

.global main
.global __vector_8

main:
    ldi temp, hi8(RAMEND)
    out SPH, temp
    ldi temp, lo8(RAMEND)
    out SPL, temp

    ldi temp, 0xFF
    out DDRD, temp

    ldi temp, 0b00000101
    out TCCR1B, temp

    ldi temp, 0b00000100
    out TIMSK, temp
    out TIFR, temp

    ldi temp, 0xFF
    out TCNT1H, temp
    out TCNT1L, temp
    
    ldi sys, 0x01
    sei
loop:
    rjmp loop

__vector_8:
    cli
    cpi sys, 0x01
    breq led2
    cpi sys, 0x02
    breq led3
    cpi sys, 0x04
    breq led4
    cpi sys, 0x08
    breq led1

vix:
    ldi temp, 0xEE
    out TCNT1H, temp
    out TCNT1L, temp

    sei
    reti

led1:
    ldi sys, 0x01
    out PORTD, sys
    rjmp vix
led2:
    ldi sys, 0x02
    out PORTD, sys
    rjmp vix
led3:
    ldi sys, 0x04
    out PORTD, sys
    rjmp vix
led4:
    ldi sys, 0x08
    out PORTD, sys
    rjmp vix
