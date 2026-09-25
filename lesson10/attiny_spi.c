;#define F_CPU 8000000UL

#include <avr/io.h>
#include <avr/interrupt.h>
#include <stdint.h>
#include <avr/iom16.h>

#define EEPROM_SIZE 256

#define CMD_READ    0x03
#define CMD_WRITE   0x02
#define CMD_WREN    0x06
#define CMD_RDSR    0x05

#define STATUS_WEL  0x02

volatile uint8_t eeprom[EEPROM_SIZE];

volatile uint8_t command;
volatile uint8_t address;
volatile uint8_t state;
volatile uint8_t status;

enum {
    STATE_COMMAND,
    STATE_ADDRESS,
    STATE_READ,
    STATE_WRITE,
    STATE_STATUS
};

static void spi_slave_reset(void)
{
    state = STATE_COMMAND;
    command = 0;
    address = 0;
    SPDR = 0x00;
}

/*
 * Вызывается после завершения каждого SPI-байта.
 */
ISR(SPI_STC_vect)
{
    uint8_t data = SPDR;

    /*
     * Если CS уже поднят, эта транзакция завершена.
     */
    if (PINB & (1 << PB2)) {
        spi_slave_reset();
        return;
    }

    switch (state) {
    case STATE_COMMAND:

        command = data;

        switch (command) {
        case CMD_READ:
        case CMD_WRITE:
            state = STATE_ADDRESS;
            SPDR = 0x00;
            break;

        case CMD_WREN:
            status |= STATUS_WEL;
            SPDR = 0x00;
            break;

        case CMD_RDSR:
            state = STATE_STATUS;
            SPDR = status;
            break;

        default:
            SPDR = 0x00;
            break;
        }

        break;

    case STATE_ADDRESS:

        address = data;

        if (command == CMD_READ) {
            state = STATE_READ;

            /*
             * Подаём первый байт данных.
             * Master должен послать дополнительный dummy-byte,
             * чтобы получить его.
             */
            SPDR = eeprom[address];
            address++;
        }
        else if (command == CMD_WRITE) {
            state = STATE_WRITE;
            SPDR = 0x00;
        }

        break;

    case STATE_READ:

        SPDR = eeprom[address];
        address++;

        /*
         * Для адреса 8 бит происходит переход 0xFF -> 0x00.
         */
        break;

    case STATE_WRITE:

        if (status & STATUS_WEL) {
            eeprom[address] = data;
            address++;
        }

        SPDR = 0x00;
        break;

    case STATE_STATUS:

        SPDR = status;
        break;
    }
}

int main(void)
{
    /*
     * PB4/MISO — выход.
     * PB2/SS, PB3/MOSI, PB5/SCK — входы.
     */
    DDRB |= (1 << PB4);

    DDRB &= ~(
        (1 << PB2) |
        (1 << PB3) |
        (1 << PB5)
    );

    /*
     * Подтяжка SS к питанию.
     */
    PORTB |= (1 << PB2);

    /*
     * SPI slave:
     * SPE  — включить SPI;
     * SPIE — разрешить прерывание SPI.
     *
     * CPOL = 0, CPHA = 0 — SPI mode 0.
     */
    SPCR =
        (1 << SPE)  |
        (1 << SPIE);

    spi_slave_reset();

    sei();

    while (1) {
        /*
         * Основная программа.
         */
    }
}
