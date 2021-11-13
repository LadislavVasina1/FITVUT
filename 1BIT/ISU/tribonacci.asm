%include "rw32-2020.inc"
;tribonacci numbers

section .data
    ; zde budou vase data

section .text
_main:
    push ebp
    mov ebp, esp
    call ReadUInt32_Silent
    
    push eax
    call tribonacci
    add esp, 4 ;pop eax
    call WriteUInt32
    
    pop ebp
    ret
    
    
    
tribonacci:
    push ebp
    mov ebp, esp
    push edx
    push ebx
    
    mov eax, [ebp+8] ;1. param
    dec eax
    cmp eax, -1
    jne preskoc
    mov eax, 0
    
preskoc:
    mov ebx, [ebp+8]
    
    cmp ebx, 2
    jna konec
    
    xor edx, edx
    
    dec ebx
    push ebx
    call tribonacci ;tribonaci n-1
    add esp, 4
    
    add edx, eax
    dec ebx
    push ebx
    call tribonacci ;tribonaci n-2
    add esp, 4
    
    add edx, eax
    dec ebx
    push ebx
    call tribonacci ;tribonaci n-3
    add esp, 4
    
    add edx, eax
    
    mov eax, edx
konec:
    pop ebx
    pop edx
    pop ebp
    ret