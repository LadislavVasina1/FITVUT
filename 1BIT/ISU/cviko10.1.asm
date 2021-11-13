%include "rw32-2018.inc"
extern _log
section .data
    format db "%f", 0
    
    ;misto_pro_1000B 
    resb 1000
section .text
funkce:
    push ebp
    mov ebp, esp
    finit
    
    fldz
    
    fld dword [ebp+8] ;st0 = paramter, st1=0.0
    fcomi st0, st1
    
    jna konec
    
    sub esp, 8
    fld dword [ebp+8]
    call _log
    add esp, 8

    sub esp, 8
    fst qword [esp]
    push format
    
    call _printf
    add esp, 12
    jmp vse_dobre
    
    konec:
        push dword 0b1111111100000000000000000000000
        fld dword[esp]
    vse_dobre:
    
    mov esp, ebp
    pop ebp
    
    ret
_main:
    push ebp
    mov ebp, esp
    
    push dword __float32__ (-1.0)
    call funkce
    add esp, 4
    
    pop ebp
    ret