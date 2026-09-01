MCU = atmega16
F_CPU = 8000000UL

CC = avr-gcc
OBJCOPY = avr-objcopy

AFLAGS = -mmcu=$(MCU) -Os -Wall \
-DF_CPU=$(F_CPU) \
-I/usr/lib/avr/include

timer_blink.elf: timer_blink.S
	$(CC) $(AFLAGS) -o $@ $<

timer_blink.hex: timer_blink.elf
	$(OBJCOPY) -O ihex -R .eeprom $< $@

clean:
	rm -f *.hex *.elf