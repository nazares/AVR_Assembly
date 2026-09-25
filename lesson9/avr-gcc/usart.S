#define __SFR_OFFSET 0

#include <avr/io.h>

#define temp R16
#define sys R17
#define count R18

.equ Bitrate, 9600
.equ BAUD, (8000000 / (16 * Bitrate)) - 1

.section .text
.global main
.global __vector_11 ; USART RX Complete Handler
.global __vector_13 ; USART TX Complete Handler

main:
    ldi temp, hi8(RAMEND)
    out SPH, temp
    ldi temp, lo8(RAMEND)
    out SPL, temp

    ldi temp, hi8(BAUD)
    out UBRRH, temp
    ldi temp, lo8(BAUD)
    out UBRRL, temp
    ldi temp, 0b11011000
    out UCSRB, temp
    ldi temp, 0b10000110
    out UCSRC, temp
    sei

loop:
    rjmp loop

__vector_11:
    cli
    sbis UCSRA, RXC 
    rjmp __vector_11
    in sys, UDR
    inc sys
    out UDR, sys
    ldi count, 0
vix_ur:
    sei
    reti

__vector_13:
    cli
    sbis UCSRA, UDRE
    rjmp __vector_13
    inc count
    cpi count, 15
    breq l1
    inc sys
    out UDR, sys
vix_ut:
    sei
    reti

l1:
    ldi count, 0
    rjmp vix_ut
