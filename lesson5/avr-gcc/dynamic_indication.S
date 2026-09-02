#define __SFR_OFFSET 0
#include <avr/io.h>

#define temp R16

#define dig1 R17
#define dig2 R18
#define dig3 R19

#define sys R20
#define try R21

ch1 = 0b10011111
ch2 = 0b00100101
ch3 = 0b00001101
ch4 = 0b10011001
ch5 = 0b01001001
ch6 = 0b01000001
ch7 = 0b00011111
ch8 = 0b00000001
ch9 = 0b00001001
ch0 = 0b00000011

.data
visible:
    .byte 6

.text

.global main
.global __vector_9
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

    ldi temp, hi8(RAMEND)
    out SPL, temp
    ldi temp, lo8(RAMEND)
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
    ldi try, ch1
    sts visible+5, try
    rcall delay
    ldi try, ch2
    sts visible+5, try
    rcall delay
    ldi try, ch3
    sts visible+5, try
    rcall delay
    ldi try, ch4
    sts visible+5, try
    rcall delay
    ldi try, ch5
    sts visible+5, try
    rcall delay
    ldi try, ch6
    sts visible+5, try
    rcall delay
    rjmp loop
delay:
    ldi dig1, 255
    ldi dig2, 255
    ldi dig3, 20

sdelay:
    dec dig1
    brne sdelay
    dec dig2
    brne sdelay
    dec dig3
    brne sdelay
    ret

__vector_9:
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
    ldi XH, hi8(visible)
    ldi XL, lo8(visible)
    ld temp, X
    out PORTB, temp
    rjmp vix
