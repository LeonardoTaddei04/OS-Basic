README FILE

For testing this OS follow this steps on linux machine:

COMPILE

i386-elf-gcc -ffreestanding -c kernel.c -o kernel.o
i386-elf-ld -o kernel.bin -Ttext 0x0600 kernel.o --oformat binary

NASM FOR bootloader:

nasm -f bin bootloader.asm -o bootloader.bin

cat bootloader.bin kernel.bin > os-image.bin

Test on QEMU
qemu-system-x86_64 -drive format=raw,file=os-image.bin

