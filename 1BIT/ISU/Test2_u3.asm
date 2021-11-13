;
;--- Úkol 3 ---
;
; Naprogramujte funkci, která vzestupnì (od nejmenšího k nejvìtšímu) seøadí 
; pole 32bitových prvkù se znaménkem. Ukazatel no pole, které máte seøadit, 
; je v registru ESI, poèet prvkù je èíslo se znaménkem a je v registru ECX. 
; Funkce task23 vrátí v EAX ukazatel na nové pole, které alokujete funkcí
; 'malloc', a kam uložíte seøazené pole prvkù.
;
; Funkci 'malloc' importujte makrem CEXTERN:
;
;   CEXTERN  malloc
;
; Funkce 'malloc' je definována takto: 
;
;   void* malloc(size_t N)
;     * N je poèet bytù, které mají být alokovány (32bitové èíslo bez znaménka)
;     * funkce vrací v EAX ukazatel (32bitové èíslo bez znaménka)
;     * funkce mùže zmìnit obsah registrù ECX a EDX
;
; Vstup:
;   * ESI = ukazatel na pùvodní pole 32bitových èísel se znaménkem (nikdy nebude NULL = 0)
;   * ECX = poèet prvkù pole (32bitové èíslo se znaménkem, vždy vìtší než 0)
;
; Výstup:
;   * v EAX vrátíte ukazatel na pole 32bitových prvkù se znaménkem 
;     seøazených vzestupnì (od nejmenšího k nejvìtšímu)
;
; Dùležité:
;   * Poèítejte s tím, že ECX > 0 a ESI != NULL.
;   * Funkce musí zachovat obsah všech registrù, kromì registru EAX a pøíznakového registru.
;   * Funkce 'malloc' mùže zmìnit obsah registrù ECX a EDX => pokud je používáte, schovejte si je.
;
; Hodnocení: až 6 b.
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
