
run:
	../zig build
	aarch64-none-elf-objcopy -O binary zig-out/bin/kernel8.elf kernel8.img
	qemu-system-aarch64 -M raspi3 -kernel kernel8.img -serial null -serial stdio