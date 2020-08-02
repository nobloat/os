nobloat_x86_64.img: ../zig-cache/bin/kernel-x86_64.elf initrd/config mkbootimg.json
	mkdir -p initrd/sys
	cp $< initrd/sys/kernel.elf
	./mkbootimg mkbootimg.json $@


qemu_x86_64: nobloat_x86_64.img
	qemu-system-x86_64 -drive file=$<,format=raw -serial stdio


clean:
	rm -f initrd/sys/kernel.elf
	rm -f nobloat_x86_64.img
