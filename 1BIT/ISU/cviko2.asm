%include "rw32-2018.inc"
bits 32
section .data
    ; zde budou vase data

    var1 dw 15
    
    array dd 10,10,10,20,30
    array1 dd 10,10,10,20,30
    array2 dd 10,10,10,20,30
section .text
_main:
mov ax, [var1]
add eax, [array]
    
    
    xor eax, eax
    mov eax, [array+0*4]
    add eax, [array1+0*4]
    mov [array2+0*4], eax
    
    xor eax, eax
    mov eax, [array+1*4]
    add eax, [array1+1*4]
    mov [array2+1*4], eax
    
    xor eax, eax
    mov eax, [array+2*4]
    add eax, [array1+2*4]
    mov [array2+2*4], eax
    
    xor eax, eax
    mov eax, [array+3*4]
    add eax, [array1+3*4]
    mov [array2+3*4], eax

    ret