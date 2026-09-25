.include "m16def.inc"

.def temp = R16
.def dig1 = R17
.def dig2 = R18
.def dig3 = R19
.def sys = R20
.def try = R21
.def count = R22

.dseg
MEMO:
    .byte 7

.cseg
.org 0
    jmp reset
.org $014
    jmp SPI_STC ; SPI Transfer Complete Handler

reset:
    ldi temp, high(RAMEND)
    out SPH, temp
    ldi temp, low(RAMEND)
    out SPL, temp

    ldi temp, 0b10110000
    out DDRB, temp
    sbi PORTB, 4
    sbi PORTB, 6
    ldi temp, 0b11010001
    out SPCR, temp
    sei

loop:
    ldi sys, 0
    ldi try, 0
    sbi PORTB, 4
    cbi PORTB, 4
    ldi temp, 0b00000110
    out SPDR, temp
    rcall delay

    ldi sys, 0
    ldi try, 1
    ldi XH, high(MEMO)
    ldi XL, low(MEMO)
    sbi PORTB, 4
    cbi PORTB, 4
    ldi temp, 0b00000011
    out SPDR, temp
    rcall delay
    rjmp loop

SPI_STC:
    cli
    sbis SPSR, SPIF
    rjmp SPI_STC
    cpi try, 0
    breq WRITE_SPI
    cpi try, 1
    breq READ_SPI

vix:
    sei
    reti

WRITE_SPI:
    inc sys
    cpi sys, 1
    breq WRITE_SPI_WR
    cpi sys, 2
    breq WRITE_SPI_ADR
    cpi sys, 10
    breq RSTD
    inc count
    out SPDR, count
    rjmp vix

WRITE_SPI_WR:
    sbi PORTB, 4
    cbi PORTB, 4
    ldi temp, 0b00000010
    out SPDR, temp
    rjmp vix

WRITE_SPI_ADR:
    ldi temp, 0x00
    out SPDR, temp
    rjmp vix

RSTD: sbi PORTB, 4
    rjmp vix

READ_SPI:
    inc sys
    cpi sys, 1
    breq READ_SPI_ADR
    cpi sys, 2
    breq READ_SPI2
    cpi sys, 2
    breq RSTD
    in temp, SPDR
    st X+, temp
    ldi temp, 0xFF
    out SPDR, temp
    rjmp vix

READ_SPI_ADR:
    ldi temp, 0x00
    out SPDR, temp
    rjmp vix

READ_SPI2:
    ldi temp, 0xFF
    out SPDR, temp
    rjmp vix

delay:
    ldi dig1, 255
    ldi dig2, 255
    ldi dig3, 100
sdelay:
    dec dig1
    brne sdelay
    dec dig2
    brne sdelay
    dec dig3
    brne sdelay
    ret