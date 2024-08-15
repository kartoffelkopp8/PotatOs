
# tools
CC = ~/opt/x86_64-elf-7.5.0-Linux-x86_64/bin/x86_64-elf-gcc 
LD = ~/opt/x86_64-elf-7.5.0-Linux-x86_64/bin/x86_64-elf-ld
AS = nasm

# flags
AS_FLAGS = -f elf64
LD_SCRIPT = -T scripts/linker.ld

# variables
SRC_DIR := src/kernel/x86_64
BUILD_DIR = build/x86_64

asm_x86_64_src := $(wildcard $(SRC_DIR)/*.asm)
asm_x86_64_obj := $(patsubst $(SRC_DIR)/%.asm, $(BUILD_DIR)/%.o, $(asm_x86_64_src))

# source- and objektfiles
asm_x86_64_src := $(wildcard $(SRC_DIR)/*.asm)
asm_x86_64_obj := $(patsubst $(SRC_DIR)/%.asm, $(BUILD_DIR)/%.o, $(asm_x86_64_src))

all: $(asm_x86_64_obj)


$(BUILD_DIR)/%.o: $(SRC_DIR)/%.asm
	@mkdir -p $(BUILD_DIR)  
	$(AS) $(AS_FLAGS) $< -o $@

.Phony: build-x86_64 clean

build-x86_64:
	$(LD) $(LD_SCRIPT) -n -o build/kernel.bin $(asm_x86_64_obj)
	cp build/kernel.bin iso/boot/ 
	grub-mkrescue -o kernelx86_64.iso iso

# Bereinigen
clean:
	rm -rf $(BUILD_DIR)
	rm build/kernel.bin
	rm iso/boot/kernel.bin
	rm kernelx86_64.iso
