CC=arm-none-eabi-gcc
OBJCOPY=arm-none-eabi-objcopy
CFLAGS=-T linker.ld -mfpu=neon -mfloat-abi=hard -mcpu=cortex-a7 -fpic -ffreestanding -O3 -nostdlib -Wextra
DRVOJBS = uart.o gpio.o
SYSOBJS = system.o startup.o
VPATH = $(patsubst %.o,driver/%,$(DRVOJBS))
os.bin: os.elf
	$(OBJCOPY) -O binary --remove-section .uncached os.elf os.bin
os.elf: boot.o $(SYSOBJS) $(DRVOJBS)
	$(CC) $(CFLAGS) -o os.elf $(DRVOJBS) $(SYSOBJS)
$(SYSOBJS): %.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@
$(DRVOJBS): %.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@
boot.o: boot.s
	$(CC) $(CFLAGS) -c boot.s

.PHONY :clean cleanbin
clean:
	rm -f *.o
cleanbin:
	rm -f os.*

install: os.bin
	sunxi-fel spl ../u-boot/spl/sunxi-spl.bin write 0x4e000000 os.bin exe 0x4e000000
