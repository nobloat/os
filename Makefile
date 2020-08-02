
nobloat_x86_64.iso:
	#todo actually copy over compiled kernel
	cd boot && touch initrd/sys/kernel.elf 
	cd boot && 
