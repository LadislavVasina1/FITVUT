;
;--- Úkol 2 ---
;
; Naprogramujte funkci, která v poli 16bitových èísel bez znaménka pA nalezne poslední výskyt 
; hodnoty x a vrátí ukazatel na tento prvek v poli. Délka pole je dána parametrem N. 
;
; Funkci jsou pøedávány parametry na zásobníku v poøadí od posledního k prvnímu (zprava doleva), parametry ze 
; zásobníku uklízí volající a výsledek funkce se vrací v registru EAX (konvence jazyka C).
;
; unsigned short* task22(const unsigned short *pA, int N, unsigned short x)
;
; Vstup:
;   pA: ukazatel na pole A (pole A obsahuje 16bitové hodnoty bez znaménka)
;    N: poèet prvkù pole A (32bitové èíslo se znaménkem)
;    x: hodnota, kterou hledáme (16bitové èíslo bez znaménka)
;
; Výstup:
;   EAX = 0, když je pA neplatný ukazatel (tj. pA == 0) nebo N <= 0 nebo hodnota x nebyla v poli nalezena
;   EAX = ukazatel na hledané èíslo v poli
;
; Dùležité:
;   Funkce musí zachovat obsah všech registrù, kromì registru EAX a pøíznakového registru.
;
; Hodnocení: až 4 b.
;

%include "rw32-2020.inc"
section .data
    pole db 1,6,3,4,5,2,6
section .text
global CMAIN
CMAIN:
    push ebp
    mov ebp,esp
    
    push 3
    push 7
    push pole
    call lasti
    add esp,12
    
    call WriteInt32
    mov esp, ebp
    pop ebp
    ret 
lasti:
    push ebp
    mov ebp,esp
    push edi
    push ebx
    push ecx
    push esi
    
    mov eax,0
    cmp word[ebp+8],0
    je skip
    cmp dword[ebp+12],0
    jle skip
    
    mov bx,[ebp+16]
    mov ax,bx
    mov ecx,[ebp+12]
    mov edi,[ebp+8]
    add edi,ecx
     mov ecx,[ebp+12]
.l:
    cmp ax,[edi]
    je .von
    sub edi,2 
    dec ecx
    cmp ecx,0
    jne .l
.von:
    mov eax,edi

    cmp ecx,0
    jne skip
    
    mov eax,0
    mov bx,[ebp+16]
    mov esi,[ebp+8]
    cmp [esi],bx
    jne skip
    mov eax,[ebp+8]
skip:
    pop esi
    pop ecx
    pop ebx
    pop edi
    mov esp, ebp
    pop ebp
    ret 