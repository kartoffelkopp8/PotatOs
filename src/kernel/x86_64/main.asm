[bits 32]
%define TEXT_RAM_COLOUR 0x04
%define TEXT_RAM 0x8b000

global _start

 section .text 
_start:
  
  mov esp, STACK_TOP
  ; check Multiboot
  

  ; check cpuid
  pushfd                  ; push eflags
  pushfd
  xor DWORD [esp], 0x00200000  ; invert ID BIT in Eflags 
  popfd                        ; set eflags to possibly inverted id bit
  pushfd 
  pop eax                      ; pop (maybe modified) eflags into eax 
  xor eax, [esp]               ; check for changes 
  popfd                        ; reset eflags to original value 
  and eax, 0x00200000          ; check if changed = one 1 bit else all 0 
  jz NO_CPUID

  ; check if long mode is available
  mov eax, 0x80000000           ; cpuid function (higest supported function)
  cpuid 
  cmp eax, 0x80000001           ; check if long mod test is supported 
  jb NO_LONG

  mov eax, 0x80000001            ; cpuid function (extended Processor info bit 29 = long mode)
  cpuid 
  and edx, 0x20000000            ; check bit
  jz NO_LONG
 
  lgdt GDT64

NO_LONG:
  mov al, 0x32
  jmp PRINT_ERROR

NO_CPUID:
  mov al, 0x31                ; error code 1
  jmp PRINT_ERROR



; error code saved in al
PRINT_ERROR:
  mov dword [0xb8000], 0x04520445
	mov dword [0xb8004], 0x043a0452
	mov dword [0xb8008], 0x04200420
	mov byte  [0xb800a], al
	hlt


SECTION .bss
STACK_BOTTOM:
  resb 1024 * 32         ; 32 kib stack
STACK_TOP:

SECTION .rodata
GDT64:
  ; 0 entry for control
  dq 0x00 
  ; Kernel level code segment 
  dq (1 << 43) | (1 << 44) | (1 << 47) < (1 << 53) ; 
  ; User level code segment 
  dq (1 << 43) | (1<< 44) | (1 << 45) | (1 << 46) | (1 << 47) | (1 << 53)
  ; Data Segment
  dq (1 << 47) 
  ; TSS Segment 
