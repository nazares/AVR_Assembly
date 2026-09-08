.include "m16def.inc"
.def temp = R16
.def dig1 = R17
.def dig2 = R18
.def dig3 = R19
.def sys = R20

;LCD
.equ FREQ                     = 8000000
.equ HD44780_CLEAR            = 0x01
.equ HD44780_HOME             = 0x02
.equ HD44780_ENTRY_MODE       = 0x04
.equ HD44780_EM_SHIFT_CURSOR  = 0
.equ HD44780_EM_SHIFT_DISPLAY = 1
.equ HD44780_EM_DECREMENT     = 0
.equ HD44780_EM_INCREMENT     = 2
.equ HD44780_DISPLAY_ONOFF    = 0x08
.equ HD44780_DISPLAY_OFF      = 0
.equ HD44780_DISPLAY_ON       = 4
.equ HD44780_CURSOR_OFF       = 0
.equ HD44780_CURSOR_ON        = 2
.equ HD44780_CURSOR_NOBLINK   = 0
.equ HD44780_CURSOR_BLINK     = 1
.equ HD44780_FUNCTION_SET     = 1
.equ HD44780_FONT5x7          = 0
.equ HD44780_FONT5x10         = 4
.equ HD44780_ONE_LINE         = 0
.equ HD44780_TWO_LINE         = 8
.equ HD44780_4_BIT            = 0
.equ HD44780_8_BIT            = 16
.equ LCD_PORT                 = PORTB
.equ LCD_DDR                  = DDRB
.equ LCD_PIN                  = PINB
.equ LCD_D4                   = 4
.equ LCD_D5                   = 5
.equ LCD_D6                   = 6
.equ LCD_D7                   = 7
.equ LCD_RS                   = 0
.equ LCD_EN                   = 2

.cseg
.org 0
rjmp reset

reset:
    ldi temp, high(RAMEND)
    out SPH, temp
    ldi temp, low(RAMEND)
    out SPL, temp

    ldi temp, 0xFF
    out DDRB, temp

    rcall LCD_init
    ldi sys, 0x30
main:
    ldi temp, (128+0x00)
    rcall LCD_Com
    ldi temp, 'N'
    rcall LCD_Dat
    ldi temp, 'a'
    rcall LCD_Dat
    ldi temp, 'z'
    rcall LCD_Dat
    ldi temp, 'a'
    rcall LCD_Dat
    ldi temp, 'r'
    rcall LCD_Dat
    ldi temp, 'e'
    rcall LCD_Dat
    ldi temp, 'n'
    rcall LCD_Dat
    ldi temp, 'k'
    rcall LCD_Dat
    ldi temp, 'o'
    rcall LCD_Dat

    ldi temp, (128+0x40)
    rcall LCD_Com
    mov temp, sys
    
    rjmp main

