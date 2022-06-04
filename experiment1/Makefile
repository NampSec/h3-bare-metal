CC=arm-none-eabi-gcc
OBJCOPY=arm-none-eabi-objcopy
CFLAGS=-T linker.ld -mfpu=neon -mfloat-abi=hard -mcpu=cortex-a7 -fpic -ffreestanding -O3 -nostdlib -Wextra
os.bin: os.elf
	$(OBJCOPY) -O binary --remove-section .uncached os.elf os.bin
os.elf: boot.o
	$(CC) $(CFLAGS) -o os.elf $<
boot.o: boot.s
	$(CC) $(CFLAGS) -c boot.s

.PHONY :clean cleanbin
clean:
	rm -f *.o
cleanbin:
	rm -f os.*

install: os.bin
	sunxi-fel spl ../u-boot/spl/sunxi-spl.bin write 0x4e000000 os.bin exe 0x4e000000
