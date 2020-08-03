ZIG_VERSION = "zig-linux-x86_64-0.6.0+6123201f0"
KERNEL_SOURCES = $(shell find . -not -d $(ZIG_VERSION) -name "*.zig")
ZIG = ./zig

all: zig nobloat_x86_64.img nobloat_aarch64.img

zig:
ifeq (, $(shell which zig))
	@echo "Zig not found, downloading it now"
	wget "https://ziglang.org/builds/$(ZIG_VERSION).tar.xz"
	tar -xf $(ZIG_VERSION).tar.xz $(ZIG_VERSION)
	ln -sf $(ZIG_VERSION)/zig zig
	rm -f $(ZIG_VERSION).tar.xz
else
	@echo "Found version zig $(shell zig version)"
	ln -sf $(shell which zig) zig
endif

#Kernel
zig-cache/bin/kernel-x86_64.elf: $(KERNEL_SOURCES)
	$(ZIG) fmt kernel/
	$(ZIG) build

zig-cache/bin/kernel-aarch64.elf: $(KERNEL_SOURCES)
	$(ZIG) fmt kernel/
	$(ZIG) build

nobloat_x86_64.img: zig-cache/bin/kernel-x86_64.elf boot/initrd/config boot/initrd/sys/mykernel.x86_64.elf boot/mkbootimg.json
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
	rm -f boot/initrd/sys/kernel.elf
	rm -f nobloat_x86_64.img
	rm -f nobloat_aarch64.img
	rm -rf zig*
