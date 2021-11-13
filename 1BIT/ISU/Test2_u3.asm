;
;--- �kol 3 ---
;
; Naprogramujte funkci, kter� vzestupn� (od nejmen��ho k nejv�t��mu) se�ad� 
; pole 32bitov�ch prvk� se znam�nkem. Ukazatel no pole, kter� m�te se�adit, 
; je v registru ESI, po�et prvk� je ��slo se znam�nkem a je v registru ECX. 
; Funkce task23 vr�t� v EAX ukazatel na nov� pole, kter� alokujete funkc�
; 'malloc', a kam ulo��te se�azen� pole prvk�.
;
; Funkci 'malloc' importujte makrem CEXTERN:
;
;   CEXTERN  malloc
;
; Funkce 'malloc' je definov�na takto: 
;
;   void* malloc(size_t N)
;     * N je po�et byt�, kter� maj� b�t alokov�ny (32bitov� ��slo bez znam�nka)
;     * funkce vrac� v EAX ukazatel (32bitov� ��slo bez znam�nka)
;     * funkce m��e zm�nit obsah registr� ECX a EDX
;
; Vstup:
;   * ESI = ukazatel na p�vodn� pole 32bitov�ch ��sel se znam�nkem (nikdy nebude NULL = 0)
;   * ECX = po�et prvk� pole (32bitov� ��slo se znam�nkem, v�dy v�t�� ne� 0)
;
; V�stup:
;   * v EAX vr�t�te ukazatel na pole 32bitov�ch prvk� se znam�nkem 
;     se�azen�ch vzestupn� (od nejmen��ho k nejv�t��mu)
;
; D�le�it�:
;   * Po��tejte s t�m, �e ECX > 0 a ESI != NULL.
;   * Funkce mus� zachovat obsah v�ech registr�, krom� registru EAX a p��znakov�ho registru.
;   * Funkce 'malloc' m��e zm�nit obsah registr� ECX a EDX => pokud je pou��v�te, schovejte si je.
;
; Hodnocen�: a� 6 b.
;
%include "rw32-2020.inc"

section .data
    values dd 40, 10, 100, 90, 20, 25
section .text
global CMAIN
CMAIN:
    push ebp
    mov ebp,esp
    
    call fun
    
    mov esp, ebp
    pop ebp
    ret 
    
    
fun:
    CEXTERN qsort
    CEXTERN malloc
    push ebp
    mov ebp,esp
    push esi
    push edi
    push ebx
    push ecx
    push
    
    mov ebx,ecx
    push compare
    push 4
    push ECX
    push ESI
    call qsort
    add esp,16
    
    mov eax,ebx
    add eax,ebx
    add eax,ebx
    add eax,ebx
    push eax
    call malloc
    add esp,4
    mov ecx,ebx
    mov edi,eax
    rep movsd
    
    pop ebx
    pop edi
    pop esi
    mov esp, ebp
    pop ebp
    ret 
    
compare:
    push ebp
    mov ebp,esp
    push ebx
    mov ebx,[ebp+8]
    mov ebx,[ebx]
    mov eax,[ebp+12]
    mov eax,[eax]
    cmp ebx,eax
    je  .eq
    jg .grater
    jl  .less
.eq:
    mov eax,0
    jmp .done
.grater:
    mov eax,1
    jmp .done
.less:
    mov eax,-1
.done:

    pop ebx
    mov esp, ebp
    pop ebp
    ret 
