%include "Rw32-2020.inc"

section .data
    array16b dw 2,4,6,8

section .text
_main:
    push ebp
    mov ebp, esp
     
    ; zde bude vas kod 

    mov al, -5
    movzx edx, al
    
    ;65000*256
    xor edx, edx
    mov ax, 65000
    mov cx, 128
    mul cx ; DX:AX = AX * CX
    shl edx, 16
    mov dx, ax
    mov eax, edx 
   
    mov ax, 256
    mov bl, 8
    div bl
    
    ;-127 / 120 (16b registr)
    
    mov ax, -127
    cwd
    mov bx, 120
    idiv bx ;DX:AX/BX -> AX
    
    ;127(32b) /120
    mov dx, 0
    mov ax, 127
    mov bx, 120
    div bx
    
    ;-1000/32
    mov ax, -1000
    cwd ;DX:AX - ok
    mov bx, 32
    idiv bx
    
    ;vypocitejte obsah lichobezniku
    ;S = (a+c)/2 *v
    ;a = 16bitove reg, c = 16bitove reg, v = 16bitove reg
    mov ax, 5 ;a
    mov cx, 7 ;c
    mov dx, 4 ;v
    mov bl, 2 ;2
    
    add ax, cx
    div bl
    mul dx
    
    ;vytvorte pole se ctyrmi 16bitovymi prvky. Nasledne vypocitejte vyraz
    ;x = pole[0]^2 + pole[1] + (pole[2]/-2*pole[3])
    xor dx, dx
    mov ax, [array16b + 0 * 2]
    mul dword [array16b + 0 * 2]
    add ax, [array16b + 1 * 2]

    mov bx, ax

    mov ax, [array16b + 3 * 2]
    mov cx, -2
    imul cx

    mov cx, ax
    mov ax, [array16b + 2 * 2]
    cwd
    idiv cx

    add bx, ax
    
    
    
    
    
       
    pop ebp
    ret