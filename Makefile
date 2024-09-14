
all: boot assemble

assemble:
	nasm -f bin -o boot.bin boot.asm

boot: assemble
	qemu-system-i386 \
	-drive file=boot.bin,if=none,id=hda,format=raw \
    -device ide-hd,drive=hda,bootindex=1 \
	-monitor stdio

.PHONY: boot assemble all