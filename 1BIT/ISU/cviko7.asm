%include "Rw32-2020.inc"
extern _malloc
extern _strcpy
section .data
    ; zde budou vase data

 a dd 10
 b dw 20
 c db 15

h_format db "%s", 0
h_world db "Hello world",0

str_dist dd 0

section .text


;fce_strcpy(char * src, char ** dst, int count)

fce_strcpy:

    push ebp
    mov ebp, esp

    mov ecx, [ebp+16]; int count
    add ecx, 1
    
    push ecx
    call _malloc
    add esp, 4

    
    cmp eax, 0
    jz error
        
    ;char * strcpy ( char * dst, const char * src)
    push dword [ebp+8]
    push dword eax
    call _strcpy
    add  esp, 8
    
    mov ebx, [ebp+12]
    mov [ebx], eax
    
    error:
    
    mov esp, ebp
    pop ebp

ret

funkce:
push ebp
mov ebp, esp

;CDECL konvence
;printf("%s", h_world)
push h_world
push h_format
call printf
add esp, 2*4

sub esp, 4*2; 8B --> vytvareni mista pro lokalni promenne funkce (jedna lok. pormenna = 4B)

mov eax, [ebp+8] ; vzdy zacinat od +8
mov ebx, [ebp+12]
mov ecx, [ebp+16]

; c -32b
; b -32b
; a -32b
; eip
; ebp
; xxx
; xxx
; ESP->

mov [ebp-4], eax ; pristup k lokalnim promennym
mov [ebp-8], ebx

mov al, 10

mov esp, ebp
pop ebp

ret  ; ret N - zasobnik uklizi volana funkce ; ret uklizi zasobnik volajici

_main:
    push ebp
    mov ebp, esp
      
    ;uint8_t f=funkce(int a, short b, char c)
    
    ;hodnoty z section data
    xor eax, eax
    mov al, [c] 
    push eax
    
    xor eax, eax
    mov ax, [b]
    push eax
    
    mov eax, [a]
    push eax
    
    call funkce
    add esp, 3*4 ;12 - 3 pushe po 4B    uklizeni zasobniku volajicim
    
    push dword 11
    push str_dist
    push h_world
    call fce_strcpy
    add esp, 12
    
    pop ebp
    ret