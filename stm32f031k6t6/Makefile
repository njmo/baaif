all: main.bin

core.o: core.s
	arm-none-eabi-as -mthumb -mcpu=cortex-m0 -o core.o core.s

main.elf: core.o
	arm-none-eabi-ld -T layout.ld core.o -o main.elf
   
main.bin: main.elf   
	arm-none-eabi-objcopy -S -O binary main.elf main.bin
	arm-none-eabi-size main.elf
clean:
	rm -rf *.elf *.o *.bin

