# nobloat-os

[![CircleCI](https://circleci.com/gh/nobloat/os.svg?style=svg)](https://circleci.com/gh/nobloat)

## Goal
- Learn operating system development
- Avoid C and evaluate how good [Zig](https://ziglang.org/) is suited for this task
- Favor simplicity over performance
- Run on x86_64 and aarch64
- Avoid legacy, assume we are in year 2020


## Long term goals
- Widget Toolkit
- Desktop UI
- Sound


## Dependencies
- `make`
- Optionally: `zig`, if no zig is found, make will download it.
- Optionally: `qemu-system-x86_64` or `qemu-system-aarch64` to run the OS

## Build
- make

## Run
- `make qemu_x86_64`
- `make qemu_aarch64`

## Ressources
- https://gitlab.com/bztsrc/bootboot/
- https://intermezzos.github.io/book/first-edition/preface.html
- https://github.com/SerenityOS/serenity
- https://os.phil-opp.com/
- https://wiki.osdev.org/Main_Page
- https://github.com/jzck/kernel-zig
- https://github.com/AndreaOrru/zen
- https://github.com/ZystemOS/pluto
- https://github.com/longld/peda
- https://wiki.osdev.org/PC_Screen_Font
- https://gitlab.com/bztsrc/scalable-font2