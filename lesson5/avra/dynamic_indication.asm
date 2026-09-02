.include "m16def.inc"
.def temp = R16
.def dig1 = R17
.def dig2 = R18
.def dig3 = R19
.def sys = R20
.def try = R21

.equ ch1 = 0b10011111
.equ ch2 = 0b00100101
.equ ch3 = 0b00001101
.equ ch4 = 0b10011001
.equ ch5 = 0b01001001
.equ ch6 = 0b01000001
.equ ch7 = 0b00011111
.equ ch8 = 0b00000001
.equ ch9 = 0b00001001
.equ ch0 = 0b00000011
.equ chA = 0b01111111
.equ chB = 0b10111111
.equ chC = 0b11011111
.equ chD = 0b11101111
.equ chE = 0b11110111
.equ chF = 0b11111011

.dseg
visible:
.byte 6
.cseg
.org 0
    jmp main
.org $012
    jmp TIM0_OVF ; Timer0 Overflow Handler
main:
    ldi temp, ch1
    sts visible, temp
    ldi temp, ch2
    sts visible+1, temp
    ldi temp, ch3
    sts visible+2, temp
    ldi temp, ch4
    sts visible+3, temp
    ldi temp, ch5
    sts visible+4, temp
    ;ldi temp, ch6
    ;sts visible+5, temp

    ldi temp, high(RAMEND)
    out SPL, temp
    ldi temp, low(RAMEND)
    out SPL, temp

    ldi temp, 0xFF
    out DDRB, temp
    out DDRD, temp

    ldi temp, 0b00000010
    out TCCR0, temp
    ldi temp, 0b00000001
    out TIFR, temp
    out TIMSK, temp
    ldi temp, 0xFE
    out TCNT0, temp
    ldi sys, 0b10000000
sei
loop:
    ldi try, chB
    sts visible+5, try
    rcall delay
    ldi try, chC
    sts visible+5, try
    rcall delay
    ldi try, chD
    sts visible+5, try
    rcall delay
    ldi try, chE
    sts visible+5, try
    rcall delay
    ldi try, chF
    sts visible+5, try
    rcall delay
    ldi try, chA
    sts visible+5, try
    rcall delay
    ;ldi try, ch7
    ;sts visible+5, try
    ;rcall delay
    ;ldi try, ch8
    ;sts visible+5, try
    ;rcall delay
    ;ldi try, ch9
    ;sts visible+5, try
    ;rcall delay
    ;ldi try, ch0
    ;sts visible+5, try
    ;rcall delay

    rjmp loop

delay:
    ldi dig1, 255
    ldi dig2, 255
    ldi dig3, 5

sdelay:
    dec dig1
    brne sdelay
    dec dig2
    brne sdelay
    dec dig3
    brne sdelay
    ret

TIM0_OVF:
    cli
    lsr sys
    cpi sys, 0b00000010
    breq l1
    out PORTD, sys
    ld temp, X+
    ld temp, X
    out PORTB, temp
vix:
    ldi temp, 0x00
    out TCNT0, temp
    sei
    reti
l1:
    ldi sys, 0b10000000
    out PORTD, sys
    ldi XH, high(visible)
    ldi XL, low(visible)
    ld temp, X
    out PORTB, temp
    rjmp vix
