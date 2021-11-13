%include "Rw32-2020.inc"
extern _log10

section .data
    a dd 4.0
    b dd 5.0
    x dd 16.6
    format db "%lf", 0
    formatD db "%d", 0
    h_format db "%s", 0
    h_world db "Hello world",0
section .text
; task1(a,b)
; y = (a+b)^2 / 2
; if(y<0)  -> y=0; 
; if(y>=0) -> y
task1:
    push ebp
    mov ebp, esp
    
    finit                   ; inicializace FPU registru na 0
    
    fld dword [ebp+8]       ; load num to STack pro fp
    fld dword [ebp+12]
    
    faddp st1, st0          ; add and pop, vysledek na st0
    ;fmul st0, st0
    
    push __float32__(2.0)   ; pushnuti konstanty na esp
    fld dword [esp]         ; nahrani ^^^ na st0
    fdivp st1, st0          ; divide and pop
    
    ;push __float32__(0.0)   ; pushnuti konstanty na esp
    ;fld dword [esp]
    
    push __float32__(500.0)   ; pushnuti konstanty na esp
    fld dword [esp]
    fcomip st0, st1
    jb less
    jae aoe
    
    less:
    mov eax, 0
    jmp skip
    
    aoe:
    sub esp, 4              ; misto na 32b float
    fstp dword [esp]        ; store real and pop, ulozime na stack
    pop eax
    jmp skip
    
    sub esp, 4              ; misto na 32b float
    fstp dword [esp]        ; store real and pop, ulozime na stack
    pop eax                 ; nacteme ze stacku (mov eax, [esp])
    
    skip:
    
    mov esp, ebp
    pop ebp
    ret
 
task2:
    push ebp
    mov ebp, esp
    finit
    
    fld dword [ebp+8]
    
    sub esp, 4              ; misto na 32b float
    fstp dword [esp]        ; store real and pop, ulozime na stack
    pop eax 
    
    push eax
    call _log10
    add esp, 4
    
    push eax
    push format
    call printf
    add esp, 8
       
    mov esp, ebp
    pop ebp
  ret       
_main:
    push ebp
    mov ebp, esp
    
    push dword [b]
    push dword [a]
    call task1
    add esp, 8
    
    push dword [x]
    call task2
    add esp, 4
    
    pop ebp
    ret