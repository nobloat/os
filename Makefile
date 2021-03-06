ZIG_VERSION = zig-linux-x86_64-0.9.0-dev.4+ddf9c40bc
KERNEL_SOURCES = $(shell find . -name "*.zig" | grep -v $(ZIG_VERSION))
ZIG = ./zig

.PHONY: zls

all: zig nobloat_x86_64.img nobloat_aarch64.img

zig:
ifeq (, $(shell which zig))
	@echo "Zig not found, downloading it now"
	wget "https://ziglang.org/builds/$(ZIG_VERSION).tar.xz"
	tar -xvf $(ZIG_VERSION).tar.xz $(ZIG_VERSION)
	ln -sf $(ZIG_VERSION)/zig zig
	rm -f $(ZIG_VERSION).tar.xz
else
	@echo "Found version zig $(shell zig version)"
	ln -sf $(shell which zig) zig
endif

zls: 
	git clone --recurse-submodules https://github.com/zigtools/zls
	cd zls && ../zig build -Drelease-safe

test: test_x86_64.img
	zig build test
	qemu-system-x86_64 -drive file=$<,format=raw -device "isa-debug-exit,iobase=0xf4,iosize=0x04"  -smp 4 -serial stdio

#mkbootimg
 boot/mkbootimg/mkbootimg: $(shell find . -name "boot/mkbootimg/*.*")
	cd boot/mkbootimg && make

#Kernel
zig-out/bin/kernel-x86_64.elf: $(KERNEL_SOURCES)
	$(ZIG) fmt kernel/
	$(ZIG) build

zig-out/bin/kernel-aarch64.elf: $(KERNEL_SOURCES)
	$(ZIG) fmt kernel/
	$(ZIG) build

zig-out/bin/test-x86_64.elf: $(KERNEL_SOURCES)
	$(ZIG) fmt kernel/
	$(ZIG) build test

zig-out/bin/test-aarch64.elf: $(KERNEL_SOURCES)
	$(ZIG) fmt kernel/
	$(ZIG) build test

test_x86_64.img: zig-out/bin/test-x86_64.elf boot/initrd/config boot/mkbootimg.json boot/mkbootimg/mkbootimg
	mkdir -p boot/initrd/sys
	#strip -s -K mmio -K fb -K bootboot -K environment $<
	cp $< boot/initrd/sys/kernel.elf
	cd boot && ./mkbootimg/mkbootimg mkbootimg.json ../$@

test_aarch64.img: zig-out/bin/test-x86_64.elf boot/initrd/config boot/mkbootimg.json boot/mkbootimg/mkbootimg
	mkdir -p boot/initrd/sys
	#strip -s -K mmio -K fb -K bootboot -K environment $<
	cp $< boot/initrd/sys/kernel.elf
	cd boot && ./mkbootimg/mkbootimg mkbootimg.json ../$@

nobloat_x86_64.img: zig-out/bin/kernel-x86_64.elf boot/initrd/config boot/mkbootimg.json boot/mkbootimg/mkbootimg
	mkdir -p boot/initrd/sys
	#strip -s -K mmio -K fb -K bootboot -K environment $<
	cp $< boot/initrd/sys/kernel.elf
	cd boot && ./mkbootimg/mkbootimg mkbootimg.json ../$@

nobloat_aarch64.img: zig-out/bin/kernel-aarch64.elf boot/initrd/config boot/mkbootimg.json boot/mkbootimg/mkbootimg 
	mkdir -p boot/initrd/sys
	#strip -s -K mmio -K fb -K bootboot -K environment $<
	cp $< boot/initrd/sys/kernel.elf
	cd boot && ./mkbootimg/mkbootimg mkbootimg.json ../$@


qemu_x86_64: nobloat_x86_64.img
	qemu-system-x86_64 -drive file=$<,format=raw -device "isa-debug-exit,iobase=0xf4,iosize=0x04"  -smp 4 -serial stdio

qemu_aarch64: nobloat_aarch64.img
	qemu-system-aarch64 -M raspi3 -kernel boot/bootboot.img -drive file=$<,if=sd,format=raw -serial stdio

debug_qemu_x86_64: nobloat_x86_64.img
	qemu-system-x86_64 -drive file=$<,format=raw -smp 4 -serial stdio -S -s &
	gdb zig-out/bin/kernel-x86_64.elf -ex "target remote localhost:1234" -ex "b _start"

update-docker-image: Dockerfile
	docker build -t nobloat/os .
	docker push nobloat/os

clean:
	rm -f boot/initrd/sys/kernel.elf
	rm -f *.img
	rm -rf zig*
	cd boot/mkbootimg && make clean
	rm -rf zls
