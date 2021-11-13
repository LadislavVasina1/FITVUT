;           
;--- Úkol 1 --- 
;
; Naprogramujte funkci, která zkopíruje pole 8bitových hodnot z pole, na které
; ukazuje registr EAX do pole, na který ukazuje registr EBX. Poèet prvkù obou polí je v registru ECX.
;
; Vstup:
;   EAX = ukazatel na pole 8bitových hodnot, které chci zkopírovat (32bitová hodnota, vždy rùzná od 0)
;   EBX = ukazatel na místo, kam chci pole EAX zkopírovat (32bitová hodnota, vždy rùzná od 0)
;   ECX = poèet prvkù polí (32bitová hodnota bez znaménka, vždy vìtší než 0)
;
; Výstup:
;   Kopie pole z adresy EAX na adresu EBX.
;
; Dùležité:
;   Funkce NEmusí zachovat obsah registrù.
;
; Hodnocení: až 2 b.
;


%include "rw32-2020.inc"

section .data
    ; zde budou vase data
    pole db 0, -6, -5, -4, -3, -2, -1, 0, 0, 0, 0, 0
    pole1 db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
section .text
_main:
    push ebp
    mov ebp, esp
    mov eax, pole
    mov ebx, pole1
    mov ecx, 12

l:
    mov dl, byte[eax]
    mov [ebx], dl
    inc ebx
    inc eax
    loop l
    
    ; zde bude vas kod
    mov esp, ebp
    pop ebp
    ret
