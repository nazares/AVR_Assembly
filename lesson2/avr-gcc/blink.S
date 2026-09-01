#define __SFR_OFFSET 0
#include <avr/io.h>

#define temp R16
#define dc1 R17
#define dc2 R18
#define dc3 R19

.text
.global reset

reset:
    ldi temp, hi8(RAMEND)
    out SPH, temp
    ldi temp, lo8(RAMEND)
    out SPL, temp

    ldi temp, 0xFF
    out DDRB, temp

    ldi temp, 0x00
    out DDRA, temp

    ldi temp, 0xFF
    out PORTA, temp

main:
    sbic PINA, 0
    rjmp main
    ldi temp, 0x01
    out PORTB, temp
    rcall delay
    ldi temp, 0x02
    out PORTB, temp
    rcall delay
    ldi temp, 0x04
    out PORTB, temp
    rcall delay
    ldi temp, 0x00
    out PORTB, temp
    rcall delay
    rjmp main

delay:
    ldi dc1, 255
    ldi dc2, 255
    li dc3, 10
sdelay:
    dec dc1
    brne sdelay
    dec dc2
    brne sdelay
    dec dc3
    brne sdelay

ret
