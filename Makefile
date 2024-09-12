
all: boot assemble

assemble:
	nasm -f bin -o boot.bin boot.asm

boot: assemble
	qemu-system-i386 \
	-drive file=boot.bin,if=none,id=disk1 \
    -device ide-hd,drive=disk1,bootindex=1

.PHONY: boot assemble all