#define __SFR_OFFSET 0
#include <avr/io.h>
#define temp R16

.section .text
.global main
.global __vector_16

main:
    ldi temp, hi8(RAMEND)
    out SPH, temp
    ldi temp, lo8(RAMEND)
    out SPL, temp

    ldi temp, 0xFF
    out DDRD, temp

    ldi temp, 0b00011000
    out ACSR, temp

    sei

loop:
    rjmp loop

__vector_16:
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