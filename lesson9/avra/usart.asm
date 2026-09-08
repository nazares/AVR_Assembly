.include "m16def.inc"
.def temp = R16
.def sys = R17
.def count = R18
.equ Bitrate = 9600
.equ BAUD = 8000000 / (16 * Bitrate) - 1

.cseg
.org 0
    jmp reset
.org $016
    jmp USART_RXC ; USART RX Complete Handler
.org $01A
    jmp USART_TXC ; USART TX Complete Handler

reset:
    ldi temp, high(RAMEND)
    out SPH, temp
    ldi temp, low(RAMEND)
    out SPL, temp

    ldi temp, high(BAUD)
    out UBRRH, temp
    ldi temp, low(BAUD)
    out UBRRL, temp
    ldi temp, 0b11011000
    out UCSRB, temp
    ldi temp, 0b10000110
    out UCSRC, temp
    sei

main:
    rjmp main

USART_RXC:
    cli
    sbis UCSRA, RXC 
    rjmp USART_RXC
    in sys, UDR
    inc sys
    out UDR, sys
    ldi count, 0
vix_ur:
    sei
    reti

USART_TXC:
    cli
    sbis UCSRA, UDRE
    rjmp USART_TXC
    inc count
    cpi count, 15
    breq L1
    inc sys
    out UDR, sys
vix_ut:
    sei
    reti

L1:
    ldi count, 0
    rjmp vix_ut