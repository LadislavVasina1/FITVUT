%include "Rw32-2020.inc"

section .data
    pole_1 dw 1,2,3,-420,5,6,7,8
    pole_2 dd 1,2,3,0,5,6,7,8
    
    ;a db 2
    ;b db 3
    ;c dw 10
    ;d dd 4
    ;x dd 0
    

    je_prv db "Je prvocislo", 0
    neni_prv db "Neni prvocislo", 0
    
    a dd 5000
    b dw 200
    c db 12
    x db 7
section .text
_main:
    push ebp
    mov ebp, esp
    
    
    

    
    ;*****************************
;    ax^2 + bx +c
    xor eax, eax
    mov al, [x]
    mul al
    mov edx, [a]
    mul edx
    mov ebx, eax
    
    xor eax, eax
    mov ax, [b]
    mov cl, [x]
    mul cl
    xor ecx, ecx
    mov cl, [c]
    add eax, ecx
    
    add eax, ebx
    

    
    

    
    ;*****************************
    ;xor ax, ax
    ;mov ax, [pole_1 + 3*2]
    ;add ax, [pole_1 + 5*2]
    ;cwde
    ;mov [pole_2 + 3*4], eax
    ;*****************************
    ;POCITANI 1 binarnich V CISLE
    ;call ReadUInt16_Silent
    ;
    ;xor ebx, ebx
    ;
    ;mov cl, 15
;for:    
    ;shr ax, 1
    ;adc bl, 0
    
    ;sub cl, 1
    ;jnc for
    
    ;mov al, bl
    ;call WriteUInt8
    ;*****************************  
    ;PROHOZENI BITU  
    ;mov al, 7
    ;call WriteBin8
    ;mov cl, 7
;for:    
    ;shl al, 1
    ;rcr bl, 1
    ;sub cl, 1
    ;jnc for
    
    ;mov al, bl
    
    ;call WriteNewLine
    ;call WriteUInt8
    ;*****************************  
    ; PROHAZOVANI BYTU
    ;xor eax, eax
    ;mov eax, 0xDDCCBBAA
    ;rol ax, 8 ;NEBO LZE xchg al, ah 
    ;rol eax, 16
    ;rol ax, 8 ;NEBO LZE xchg al, ah                ;VYSTUP 0XAABBCCDD
    
    ;call WriteHex32
    ;xor eax, eax
    ;***************************** 
    ;((a + b) * c - 42) / d        SE ZNAMENKEM
    ;mov al, [a]
    ;add al, [b]
    ;cbw
    ;imul word [c]; DX:AX
    ;sub ax, 42
    ;cwde; EAX <- AX
    ;cdq; EDX:EAX <- EAX
    ;idiv dword [d]
    ;mov dword [x], eax
    
    ;call WriteInt16
    ;*****************************
    ;((a + b) * c - 42) / d        BEZ ZNAMENKA
    
    ;xor eax, eax
    ;mov al, [a]
    ;add al, [b]
    ;mul word [c]; DX:AX - nasledujici 3 radky to vezmou z DX:AX shiftnou DX do horni casti EDX, pak do ted prazdne DX da AX a pak da EDX do EAX
    ;shl edx, 16
    ;mov dx, ax
    ;mov eax, edx
    ;sub ax, 42
    ;xor edx, edx
    ;div dword [d] ; EAX=EDX:EAX / [d]  !!! % modulo se da do EDX !!!
    ;mov dword [x], eax
    
    ;call WriteInt32
    ;*****************************
    ;Program nacte uzivatelem zadane UInt16 cislo a vypise jestli je prvocislo nebo ne
    ;call ReadUInt16_Silent
    
    ;mov bx, ax ; BX = cislo, ktere testujeme
    ;mov cx, ax ; CX = cislo, kterym iterujeme a delime

    ;cmp cx, 1
    ;jbe vyskoc_neni_prvocislo
;for:

    ;sub cx, 1
    ;cmp cx, 1
    ;je vyskoc_je_prvocislo
    
    ;mov ax, bx
    ;xor edx, edx
    ;div cx        
    
    ;cmp dx, 0
    ;je vyskoc_neni_prvocislo               
                          
    ;jmp for
;vyskoc_je_prvocislo:
    ;mov esi, je_prv 
    ;jmp konec
;vyskoc_neni_prvocislo:    
    ;mov esi, neni_prv    
;konec:    
    ;call WriteString
    ;*****************************
    ;vypocitej BEZ znamenka x = (a^2 +b)^2    
    
    ;mov al, [a]
    ;mul al ; AX = AL * SRC(zde AL)

    ;xor bx, bx
    ;mov bl, [b]
    
    ;add ax, bx
    
    ;mul ax ;DX:AX = AX*SRC
    ;shl edx, 16
    ;mov dx, ax
    ;mov eax, edx 
    
    ;call WriteUInt32
    ;*****************************
    ;Vytvor program, ktery nalezne vsechna reseni (Int8) rovnice: a^3 = b^2 - 17
    ;Omez velikost a a v na 8b se znamenkem    
    ;mov bl, 0 ; bl = [b]
;    mov cl, 0 ; cl = [a]
;    
;for:
;    mov al, cl
;    cbw
;    cwde
;    mov edx, eax
;    imul al ; AX = a^2
;    cwde
;    imul edx
;    mov edx, eax
;    
;    mov al, bl
;    imul al
;    sub ax, 17
;    cwde
;    
;    cmp eax, edx
;    jne preskoc_vypis
;    
;    mov al, cl
;    call WriteInt8    
;    mov al, 32
;    call WriteChar
;    mov al, bl
;    call WriteInt8
;    call WriteNewLine
;    
; preskoc_vypis:   
;    add bl, 1
;    jnc for
;    add cl, 1    
;    jnc for
    

   
    pop ebp
    ret