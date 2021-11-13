%include "rw32-2018.inc"

section .data
    param_1 dd 13
    param_2 dd 42   

section .text
_main:
    push ebp
    mov ebp, esp
    
    ;int fce(int param_1, int param_2);
    push dword [param_2]
    push dword [param_1]
    call _fce
    add esp, 4*2 ; 2parametry * 4B
    
    call WriteInt32
    pop ebp
    ret 
    
_fce:
    push ebp
    mov ebp, esp 
    
    sub esp, 12 ; 3 lokalni promenne
   
    push edx ; zachovani registru
    
    mov eax, [ebp+8] ; pristup k parametrum  
    mov [ebp-4], eax ; [ebp-4] = 1. lokalni promenna
    
    mov edx, [ebp+12]
    add edx, [ebp-4]
    
    mov eax, edx
    
    pop edx; zachovani registru
    mov esp, ebp
    pop ebp
    ret