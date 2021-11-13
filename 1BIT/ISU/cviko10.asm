%include "rw32-2018.inc"
extern _printf
section .data
    ; zde budou vase data
    r dd 7.7
    h_format db "%f",0
section .text
kruh:
    push ebp ; snizuje ukazatel ESP
    mov ebp, esp
    finit
    fldpi
    fld dword [ebp+8]
    fmul st0, st0 ; r^2
    fmul st0, st1 ; pi*r^2   
    
    sub esp, 8              
    fstp qword [esp]
       
    push h_format
    call _printf
    add esp, 12
    
    ;base+index*scale+offset      
    ;mov eax, [ebx+]
    mov esp, ebp
    pop ebp
ret

; Vytvor funkci ktera bude mit jeden vstupni parametr (polomer) bude vracet float a bude vracet obsah kruhu
_main:
    push ebp
    mov ebp, esp
    
    push dword [r]
    call kruh
    add esp, 4
    pop ebp
    ret