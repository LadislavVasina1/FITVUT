extern _printf
extern _malloc
extern _strcpy
extern _scanf
 
section .data
    ; zde budou vase data
 
 
a dd 10
b dw 20
c db 15
 
 
h_format db "%s",0
h_world db "Hello world",0
str_dist dd 0
scanf1 resb 50
scanf2 resb 50
 
 
 
global _main
 
 
section .bss
 
 
 
section .text
 
 
 
;fce_strcpy(char * src, char ** dst, int count)
 
 
fce_strcpy:
    push ebp
    mov ebp, esp
    
    mov ecx, [ebp+16]
    add ecx, 1
    
    push ecx
    call _malloc
    add esp, 4
    
    cmp eax, 0
    jz error
    
        
    ;char * strcpy ( char * destination, const char * source );
    
    push dword [ebp+8]
    push dword eax
    call _strcpy
    add esp, 8
    
    
    mov ebx, [ebp+12]
    mov [ebx], eax
    
error:
 
    mov esp,ebp
    pop ebp
ret
 
 
;void replace(char *word, char *string, int string_length, int word_length)
 
replace:
push ebp
mov ebp, esp
 
 
;ebx - delka slova
mov ebx, [ebp+20]
mov edx,ebx
;ecx - delka retezce
mov ecx, [ebp+16]
 
sub ecx, ebx
 
mov esi, [ebp+12]
mov edi, [ebp+8]
 
outer:
    cmp ecx, 0
    jz outer_end
 
    ;cast, ktera provadi vyhledavani
 
    mov ebx, edx
    inner:
        cmp ebx,0
        jz inner_end
        
        ; |A|B|C|D|xE|F|G
        push ecx
        add ecx, ebx
        mov al, [esi+ecx-2]
        pop ecx
 
        cmp al, [edi+ebx*1-1]
        jnz inner_ne_end
        
        dec ebx
        jmp inner
    inner_end:

    ;cast, ktera provadi nahrazovani
    mov ebx, edx
 
    inner2:
        cmp ebx,0
        jz inner_end2
    
        ; |A|B|C|D|xE|F|G
        push ecx
        add ecx, ebx
        mov [esi+ecx-2], byte 'x'
        pop ecx

        dec ebx
        jmp inner2
    inner_end2:
    
    
    inner_ne_end:
    
    pop ebx

    
    dec ecx
    jmp outer
outer_end:
 
 
mov esp, ebp
pop ebp
_main:
    push ebp
    mov ebp, esp
    
    ; zde bude vas kod
    
    
    push scanf1
    push h_format
    call _scanf
    add esp, 8
    
    
    push scanf2
    push h_format
    call _scanf
    add esp, 8
    
    
    ;void replace(char *word, char *string, int string_length, int word_length)
    
    push dword 3
    push dword 7
    push scanf2
    push scanf1
    call replace
    add esp, 16
    
    
    
    
    push dword 11
    push str_dist
    push h_world
    
    call fce_strcpy
    add esp, 12
    
    
    
    
 
    pop ebp
    ret