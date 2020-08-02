
kernel: zig-cache/bin/kernel-x86_64.elf

zig-cache/bin/kernel-x86_64.elf:
	zig build

nobloat_x86_64.img: zig-cache/bin/kernel-x86_64.elf boot/initrd/config boot/mkbootimg.json
	mkdir -p boot/initrd/sys
	cp $< boot/initrd/sys/kernel.elf
	cd boot && ./mkbootimg mkbootimg.json ../$@


qemu_x86_64: nobloat_x86_64.img
	qemu-system-x86_64 -drive file=$<,format=raw -serial stdio


clean:
	rm -f boot/initrd/sys/kernel.elf
	rm -f boot/nobloat_x86_64.img
