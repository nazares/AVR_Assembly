#define __SFR_OFFSET 0

#include <avr/io.h>

#define temp R16

.section .text

.global main
.global __vector_1 ; IRQ0 Handler

main:
    ldi temp, hi8(RAMEND)
    out SPH, temp
    ldi temp, lo8(RAMEND)
    out SPL, temp

    ldi temp, 0b01000000
    out GICR, temp
    ldi temp, 0b00000010
    out MCUCR, temp

    sei

loop:
    rjmp loop

__vector_1:
    cli
    sbis PORTB, 0
    rjmp l1

    cbi PORTB, 0

vix:
    sei
    reti

l1: sbi PORTB, 0
    rjmp vix