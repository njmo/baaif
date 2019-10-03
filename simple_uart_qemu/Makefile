
test.bin : test.elf
	arm-none-eabi-objcopy -O binary test.elf test.bin
test.elf : test.o startup.o
	arm-none-eabi-ld -T test.ld test.o startup.o -o test.elf
startup.o : startup.s
	arm-none-eabi-as -mcpu=arm1176jzf-s -g startup.s -o startup.o
test.o : test.c
	arm-none-eabi-gcc -c -mcpu=arm1176jzf-s -g test.c -o test.o

run_qemu :
	qemu-system-arm -M versatilepb -m 128M -nographic -kernel test.bin
