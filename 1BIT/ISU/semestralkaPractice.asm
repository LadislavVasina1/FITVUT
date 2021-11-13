%include "rw32-2018.inc"

section .data
    ; zde budou vase data

section .text

fce:
push ebp
mov ebp, esp

mov esp, ebp
pop ebp

ret


_main:
    push ebp
    mov ebp, esp
    
    stc
    mov ah, -100
    sub ah, 50
    
;    finit
;    push __float32__(3.0)
;    fld dword [esp]
;    push __float32__(4.0)
;    fld dword [esp]
;    push __float32__(-6.0)
;    fld dword [esp]
;    fcomip

;mov cl, 76
;sar cl, 3    
    
;mov dh, 76
;stc
;sub dh, -96 
       
;stc
;mov dh, -8
;add dh, 13

;mov al, 93
;stc
;sbb al, 28

;mov ax, 0
;not ax

;mov bh, 106
;xor bh, 95

;mov  bl, -61
;stc
;shr bl, 2

;mov bh, -22
;stc
;rol bh, 5

;mov ax, 0b0000111100001111
;mov dx, 85
;cwd

;mov al, 0b10001111
;cbw

;mov al, 9
;mov ah, 123
;mov bl, 7
;mul bl

;mov ax, 5
;mov dx, 1
;mov bx, 800
;div bx

finit    
    push __float32__(4.0)
    fld dword [esp]
    push __float32__(8.0)
    fld dword [esp]
    push __float32__(16.0)
    fld dword [esp]
    faddp st2, st0
    

;mov eax, 25
;sub eax, 25
;mov ebx, -381 
;cdq
;imul ebx   ; -381*(EAX-25) v EAX
;mov ecx, eax ; -381*(EAX-25) v ECX
;
;mov eax, 25
;mov ebx, 5
;cdq
;idiv ebx ;EAX/EBX
;sub ecx, eax ; -381*(EAX-25) - EAX/EBX
;mov eax, ecx ; -381*(EAX-25) - EAX/EBX v EAX
;
;mov ebx, 5
;add eax, ebx ; -381*(EAX-25) - EAX/EBX + EBX v EAX
;
;mov ebx, eax ; -381*(EAX-25) - EAX/EBX + EBX v EBX
;
;mov ecx, 2
;mov eax, 8
;cdq
;imul ecx   ; 8*ECX v EAX
;
;add eax, ebx
;sub eax, 935

;mov eax, 25
;sub eax, 25
;
;mov ebx, eax
;mov eax, -381
;cdq
;imul ebx
;mov ecx, eax ; -381*(EAX-25) v ECX
;mov eax, 25
;mov ebx, 25
;cdq
;idiv ebx
;sub ecx, eax ; -381*(EAX-25)-EAX/EBX v ECX
;add ecx, ebx ; -381*(EAX-25)-EAX/EBX + EBX v ECX
;mov ebx, ecx ; -381*(EAX-25)-EAX/EBX + EBX v EBX
;mov eax, 130
;cdq
;mov esi, 8
;imul esi    ; 8*ECX v EAX
;mov ecx, eax ; 8*ECX v ECX
;sub ecx, 935 ; 8*ECX -935 v ECX
;add ebx, ecx
;mov eax, ebx

;stc
;mov ch, -76
;sub ch, 123

;mov bh, -88
;or bh, 97

;stc
;mov al, -5
;sar al, 7

;mov dl, -47
;stc
;ror dl, 5

;mov ax, 50
;mov dx, 10
;cwd
;

   
    pop ebp
    ret