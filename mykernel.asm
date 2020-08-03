
boot/initrd/sys/mykernel.x86_64.elf:     file format elf64-x86-64


Disassembly of section .text:

ffffffffffe02000 <environment+0x1000>:
ffffffffffe02000:	55                   	push   %rbp
ffffffffffe02001:	48 89 e5             	mov    %rsp,%rbp
ffffffffffe02004:	48 83 ec 10          	sub    $0x10,%rsp
ffffffffffe02008:	48 c7 c0 00 00 e0 ff 	mov    $0xffffffffffe00000,%rax
ffffffffffe0200f:	8b 40 3c             	mov    0x3c(%rax),%eax
ffffffffffe02012:	89 45 f8             	mov    %eax,-0x8(%rbp)
ffffffffffe02015:	48 c7 c0 00 00 e0 ff 	mov    $0xffffffffffe00000,%rax
ffffffffffe0201c:	8b 40 34             	mov    0x34(%rax),%eax
ffffffffffe0201f:	89 45 f4             	mov    %eax,-0xc(%rbp)
ffffffffffe02022:	48 c7 c0 00 00 e0 ff 	mov    $0xffffffffffe00000,%rax
ffffffffffe02029:	8b 40 38             	mov    0x38(%rax),%eax
ffffffffffe0202c:	89 45 f0             	mov    %eax,-0x10(%rbp)
ffffffffffe0202f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
ffffffffffe02036:	eb 28                	jmp    ffffffffffe02060 <environment+0x1060>
ffffffffffe02038:	8b 45 f8             	mov    -0x8(%rbp),%eax
ffffffffffe0203b:	0f af 45 fc          	imul   -0x4(%rbp),%eax
ffffffffffe0203f:	48 63 d0             	movslq %eax,%rdx
ffffffffffe02042:	8b 45 f4             	mov    -0xc(%rbp),%eax
ffffffffffe02045:	01 c0                	add    %eax,%eax
ffffffffffe02047:	48 98                	cltq   
ffffffffffe02049:	48 01 c2             	add    %rax,%rdx
ffffffffffe0204c:	48 c7 c0 00 00 00 fc 	mov    $0xfffffffffc000000,%rax
ffffffffffe02053:	48 01 d0             	add    %rdx,%rax
ffffffffffe02056:	c7 00 ff ff ff 00    	movl   $0xffffff,(%rax)
ffffffffffe0205c:	83 45 fc 01          	addl   $0x1,-0x4(%rbp)
ffffffffffe02060:	8b 45 fc             	mov    -0x4(%rbp),%eax
ffffffffffe02063:	3b 45 f0             	cmp    -0x10(%rbp),%eax
ffffffffffe02066:	7c d0                	jl     ffffffffffe02038 <environment+0x1038>
ffffffffffe02068:	eb fe                	jmp    ffffffffffe02068 <environment+0x1068>

Disassembly of section .bss:

ffffffffffe0206a <.bss>:
ffffffffffe0206a:	00 00                	add    %al,(%rax)
ffffffffffe0206c:	00 00                	add    %al,(%rax)
	...
