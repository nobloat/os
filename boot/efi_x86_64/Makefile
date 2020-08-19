
boot.img: zig-cache/bin/bootx64.efi
	dd if=/dev/zero of=boot.img bs=1k count=1440
	mformat -i boot.img -f 1440 ::
	mmd -i boot.img ::/EFI
	mmd -i boot.img ::/EFI/BOOT
	mcopy -i boot.img zig-cache/bin/bootx64.efi ::/EFI/BOOT


qemu:
	qemu-system-x86_64.exe -bios ovmf-x86_64.bin -drive format=raw,file=boot.img