%include "rw32-2018.inc"

section .data
    array_1 dw 0x12FF, 0x1, 0x8FFF, 0xF123
    array_2 db 0x12, 0x9, 0x10, 0xFF
    array_3 dd 200, 300, 356, 400, 0x0000FFFF
    array_4 dq 0x00

section .text
_main:
    push ebp
    mov ebp, esp
    
    mov ax, 65000
    mov bl, 1
    div bl
    
    ;Vypocitejte priklad (-16/2 + -5*3), vysledek prevedte na kladne cislo pomoci logickych instrukci
    mov ax, -16
    mov bl, 2
    
    idiv bl
    cbw
    mov cx, ax
    
    mov al, -5
    mov bl, 3
    imul bl
    
    add ax, cx
    
    not ax
    add ax, 1
    
    
    
    ;Vypoctete bezznamenkove vyrazu array_4[0]=(array_3[0]+(array_1[0]/array_1[1])*4)*array_3[4]
    
    ;DX:AX/BX -> AX, zbytek DX
    xor eax, eax
    mov bx, [array_1 + 1*2]
    mov dx, 0
    mov ax, [array_1 + 0*2]
    div bx
    
    mov bx, 4
    mul bx; AX*BX = DX:AX

    shl edx, 16
    or edx, eax
    
    add edx, [array_3 + 0*4]
    
    ;EAX*EDX = EDX:EAX    
    mov eax, [array_3 + 4*4]
    mul edx

    mov [array_4 + 0*4], eax
    mov [array_4 + 1*4], edx
    ;|EAX   |EDX   |
    
    ;Vypoctete znamenkove vyraz array_3[0] = array_1[2]/array_1[0]-array_3[3]/array_3[0]
    xor eax, eax
    mov bx, [array_1 + 0*2]
    mov ax, [array_1 + 2*2]
    cwd
    ;DX:AX/BX
    idiv bx
    
    xor ecx, ecx
    mov cx, ax
    
    mov ebx, 0
    mov eax, [array_3 + 3*4]
    mov ebx, [array_3 + 0*4]
    ;EDX:EAX/EBX
    cdq
    idiv ebx ;-> EAX
    
    sub ecx, eax
    mov [array_3 + 0*4], ecx
    
    ;Zamente horni polovinu registru EBX s dolni polovinou registru EAX
    mov eax, 0xAAAA5678 ;->0xAAAA1234
    mov ebx, 0x1234FFFF ;->0x5678FFFF
    
;1. reseni
    rol ebx, 16
    xor ax, bx
    xor bx, ax
    xor ax, bx
    rol ebx, 16
    
;2. reseni    
    mov eax, 0xAAAA5678 ;->0xAAAA1234
    mov ebx, 0x1234FFFF ;->0x5678FFFF
    
    rol ebx, 16
    xchg ax, bx
    rol ebx, 16  
    pop ebp
    ret
    
    mov eax, 0xAAAA5678 ;->0xAAAA1234
    mov ebx, 0x1234FFFF ;->0x5678FFFF
    
;3. reseni
    mov ebx, 16
    mov cx, ax
    mov ax, bx
    mov bx, cx
    rol ebx, 16
    
    
    ret