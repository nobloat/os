all: nobloat_x86_64.img nobloat_aarch64.img

KERNEL_SOURCES = $(shell find . -name "*.zig")


#Kernel
%.elf: $(KERNEL_SOURCES)
	zig build

nobloat_x86_64.img: zig-cache/bin/kernel-x86_64.elf boot/initrd/config boot/initrd/sys/mykernel.x86_64.elf boot/mkbootimg.json
	echo $(KERNEL_SOURCES)
	mkdir -p boot/initrd/sys
	#strip -s -K mmio -K fb -K bootboot -K environment $<
	cp $< boot/initrd/sys/kernel.elf
	cd boot && ./mkbootimg mkbootimg.json ../$@

nobloat_aarch64.img: zig-cache/bin/kernel-aarch64.elf boot/initrd/config boot/mkbootimg.json
	mkdir -p boot/initrd/sys
	#strip -s -K mmio -K fb -K bootboot -K environment $<
	cp $< boot/initrd/sys/kernel.elf
	cd boot && ./mkbootimg mkbootimg.json ../$@


qemu_x86_64: nobloat_x86_64.img
	qemu-system-x86_64 -drive file=$<,format=raw -serial stdio

qemu_aarch64: nobloat_aarch64.img
	qemu-system-aarch64 -M raspi3 -kernel boot/bootboot.img -drive file=$<,if=sd,format=raw -serial stdio

debug_qemu_x86_64: nobloat_x86_64.img
	qemu-system-x86_64 -drive file=$<,format=raw -serial stdio -S -s &
	gdb zig-cache/bin/kernel-x86_64.elf -ex "target remote localhost:1234" -ex "b _start"

clean:
	rm -rf zig-cache
	rm -f boot/initrd/sys/kernel.elf
	rm -f nobloat_x86_64.img
	rm -f nobloat_aarch64.img
