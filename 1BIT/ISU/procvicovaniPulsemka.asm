%include "rw32-2018.inc"

section .data
    ; zde budou vase data

section .text
_main:
    push ebp
    mov ebp, esp
    
    mov al, 96
    mov bl, 9
    mov cl, 10
    mul cl
    add ah, bl
    mov dl, 100
    div dl
    inc ax
    add al, ah
    sub al, bl
    cmp al, 89
    jae hop1
    add al, -128
    hop1:

  
;mov al, 9
;and ax, 9
;or al, -119
;xchg al, dl
;rol ax, 8
;xor al, dl
;sar al, 4       
    
;    xor cx, cx
;    mov ax, 0b0010001011110010
;    bsf cx, ax
;    not ax
;    popcnt dx, ax

;    mov al, 64
;    mov bl, 6
;    mov cl, 10
;    mul cl
;    add ah, bl
;    mov dl, 100
;    div dl
;    inc ax
;    add al, ah
;    sub al, bl
;    cmp al, 93 ;JE AL <= 93
;    jae hop1
;    add al, -128
;    hop1:




;mov al, 0xff
;and ax, 111
;or al, 0b11101111
;xchg al, dl
;rol ax, 8
;xor al, dl
;sar al, 4

    
    
    
        
    pop ebp
    ret