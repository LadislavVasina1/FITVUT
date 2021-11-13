%include "rw32-2018.inc"

section .data
    a db 10
    b dd 20
    c dw 10
    d dw 7
    e dw 7
    q dd 0
    r dd 0

section .text
CMAIN:
    push ebp
    mov ebp,esp
        
        mov eax,0x44332211
    call task11
    
    call task12
    
    pop ebp
    ret
    
;
;--- Task 1 ---
;
; Create a function "task11" to swap bytes X1, X2, X3, X4 within the register EAX this way:
;
; original value: EAX = X4 X3 X2 X1
; result        : EAX = X4 X1 X3 X2 
;
; The argument to the function is passed in the register EAX and it returns the result 
; in the register EAX. The least significant byte is X1, the most significant byte is X4.
;
; Arguments:
;    - EAX = 32bit value
;
; Result:
;    - EAX = result
;    - the function does not have to preserve content of any register
;
task11:
    ; insert your code here
    ret
;
;--- Task 2 ---
;
; Create a function "task12" to evaluate the following expression using UNSIGNED integer arithmetic:
;
; q = (a*b + c + 23)/(8*d + e + 113) ... division quotient
; r = (a*b + c + 23)%(8*d + e + 113) ... division remainder 
;
; The arguments a, b, c, d and e are stored in the memory and are defined as follows:
;
;    [a] ...  8bit unsigned integer
;    [b] ... 32bit unsigned integer
;    [c] ... 16bit unsigned integer
;    [d] ... 16bit unsigned integer
;    [e] ... 16bit unsigned integer
;
; Store the result to the memory at the addresses q and r this way:
;
;    [q] ... lower 32 bits of the division quotient (32bit unsigned integer)
;    [r] ... division remainder (32bit unsigned integer)
;
; Important notes:
;  - do NOT take into account division by zero 
;  - the function does not have to preserve the original content of the registers
task12:
    ;(a*b + c + 23)/(8*d + e + 113)
    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx
;prava
    mov ax, [d]
    mov cl, 8
    mul ecx
    add eax, 113
    mov cx, [e]
    add eax, ecx
    mov ebx, eax
;leva
    xor eax, eax
    xor ecx, ecx

    mov al, [a]
    mov ecx, [b]
    mul ecx

    xor ecx, ecx
    mov cx, [c]
    add eax, ecx
    add eax, 23

    div ebx

    mov [q], eax
    mov [r], edx

    xor eax, eax
    ret
