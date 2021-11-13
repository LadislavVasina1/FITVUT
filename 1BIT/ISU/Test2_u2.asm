;
;--- �kol 2 ---
;
; Naprogramujte funkci, kter� v poli 16bitov�ch ��sel bez znam�nka pA nalezne posledn� v�skyt 
; hodnoty x a vr�t� ukazatel na tento prvek v poli. D�lka pole je d�na parametrem N. 
;
; Funkci jsou p�ed�v�ny parametry na z�sobn�ku v po�ad� od posledn�ho k prvn�mu (zprava doleva), parametry ze 
; z�sobn�ku ukl�z� volaj�c� a v�sledek funkce se vrac� v registru EAX (konvence jazyka C).
;
; unsigned short* task22(const unsigned short *pA, int N, unsigned short x)
;
; Vstup:
;   pA: ukazatel na pole A (pole A obsahuje 16bitov� hodnoty bez znam�nka)
;    N: po�et prvk� pole A (32bitov� ��slo se znam�nkem)
;    x: hodnota, kterou hled�me (16bitov� ��slo bez znam�nka)
;
; V�stup:
;   EAX = 0, kdy� je pA neplatn� ukazatel (tj. pA == 0) nebo N <= 0 nebo hodnota x nebyla v poli nalezena
;   EAX = ukazatel na hledan� ��slo v poli
;
; D�le�it�:
;   Funkce mus� zachovat obsah v�ech registr�, krom� registru EAX a p��znakov�ho registru.
;
; Hodnocen�: a� 4 b.
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