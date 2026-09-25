MCU = atmega8
F_CPU = 8000000UL
FILE = attiny_spi
CC = avr-gcc
OBJCOPY = avr-objcopy

AFLAGS = -mmcu=$(MCU) -Os -Wall \
-DF_CPU=$(F_CPU) \
-I/usr/lib/avr/include

$(FILE).elf: $(FILE).c
	$(CC) $(AFLAGS) -o $@ $<

$(FILE).hex: $(FILE).elf
	$(OBJCOPY) -O ihex -R .eeprom $< $@

clean:
	rm -f *.hex *.elf