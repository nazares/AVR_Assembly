.include "m16def.inc"
.def temp = R16
.def dc1 = R17
.def dc2 = R18
.def dc3 = R19

.cseg
.org 0
    jmp __reset

__reset:
    ldi temp, HIGH(RAMEND)
    out SPH, temp
    ldi temp, LOW(RAMEND)
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
    ldi dc3, 10
sbdelay:
    dec dc1
    brne sbdelay
    dec dc2
    brne sbdelay
    dec dc3
    brne sbdelay

ret 