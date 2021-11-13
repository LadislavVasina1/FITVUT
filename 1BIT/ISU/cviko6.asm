%include "Rw32-2020.inc"

section .data
    ; zde budou vase data
    str1 db "Ahoj",0
section .text
funkce:
    push ebp
    mov ebp, esp
    
    mov edx, [ebp+8]
    mov ebx, [ebp+12]
    
    mov ecx, ebx
    top:
    mov al, "#"
    call WriteChar
    loop top
    
    mov ecx, edx
    dec ecx
    call WriteNewLine
    
    mov ecx, edx
    dec ecx
    dec ecx
    stred:
    mov al, "#"
    call WriteChar
      
    mov edx, ecx
    mov ecx, ebx
    dec ecx
    dec ecx
    mezera:
    mov al, "v"
    call WriteChar
    loop mezera
    mov al, "#"
    call WriteChar
    call WriteNewLine 
    mov ecx, edx
    
    loop stred  
                
    mov ecx, ebx
    bottom:
    mov al, "#"
    call WriteChar
    loop bottom
     
    
    mov esp, ebp
    pop ebp
ret 8
_main:
    push ebp
    mov ebp, esp
    
    ;funkce(int w, int h)
    push dword 10 ;w [ebp+12]
    push dword 5 ;h [ebp+8]
    call funkce
    pop ebp
    ret