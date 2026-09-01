.include "m16def.inc"
.def temp = R16
.def sys = R17
.dseg

.cseg
.org 0
    jmp reset
.org $010
    jmp TIM1_OVF ; Timer1 Overflow Handler

reset:
    ldi temp, high(RAMEND)
    out SPH, temp
    ldi temp, low(RAMEND)
    out SPL, temp

    ldi temp, 0b00000101
    out TCCR1B, temp

    ldi temp, 0b00000100
    out TIMSK, temp
    out TIFR, temp

    ldi temp, 0xFF
    out TCNT1H, temp
    out TCNT1L, temp

    ldi sys, 0b00000001

    sei

main:
    ldi temp, 0xFF
    out DDRD, temp 
    rjmp main

TIM1_OVF:
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
    ldi sys, 0b00000001
    out PORTD, sys
    rjmp vix

led2:
    ldi sys, 0b00000010
    out PORTD, sys
    rjmp vix
led3:
    ldi sys, 0b00000100
    out PORTD, sys
    rjmp vix
led4:
    ldi sys, 0b00001000
    out PORTD, sys
    rjmp vix
