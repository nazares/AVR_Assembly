MCU = atmega16
F_CPU = 8000000UL

CC = avr-gcc
OBJCOPY = avr-objcopy

AFLAGS = -mmcu=$(MCU) -Os -Wall \
-DF_CPU=$(F_CPU) \
-I/usr/lib/avr/incude

blink.elf: blink.S
	$(CC) $(AFLAGS) -o $@ $<

blink.hex: blink.elf
	$(OBJCOPY) -O ihex -R .eeprom $< $@

clean:
	rm -f *.hex *.elf