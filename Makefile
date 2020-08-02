all: nobloat_x86_64.img nobloat_aarch64.img


kernel:
	zig build

#x86_64
zig-cache/bin/kernel-x86_64.elf:
	zig build

nobloat_x86_64.img: zig-cache/bin/kernel-x86_64.elf boot/initrd/config boot/mkbootimg.json
	mkdir -p boot/initrd/sys
	cp $< boot/initrd/sys/kernel.elf
	cd boot && ./mkbootimg mkbootimg.json ../$@

#aarch64
zig-cache/bin/kernel-aarch64.elf:
	zig build

nobloat_aarch64.img: zig-cache/bin/kernel-aarch64.elf boot/initrd/config boot/mkbootimg.json
	mkdir -p boot/initrd/sys
	cp $< boot/initrd/sys/kernel.elf
	cd boot && ./mkbootimg mkbootimg.json ../$@


qemu_x86_64: nobloat_x86_64.img
	qemu-system-x86_64 -drive file=$<,format=raw -serial stdio

qemu_aarch64: nobloat_aarch64.img
	qemu-system-aarch64 -M raspi3 -kernel boot/bootboot.img -drive file=$<,if=sd,format=raw -serial stdio


clean:
	rm -rf zig-cache
	rm -f boot/initrd/sys/kernel.elf
	rm -f boot/nobloat_x86_64.img
	rm -f boot/nobloat_aarch64.img
