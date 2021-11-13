;           
;--- �kol 1 --- 
;
; Naprogramujte funkci, kter� zkop�ruje pole 8bitov�ch hodnot z pole, na kter�
; ukazuje registr EAX do pole, na kter� ukazuje registr EBX. Po�et prvk� obou pol� je v registru ECX.
;
; Vstup:
;   EAX = ukazatel na pole 8bitov�ch hodnot, kter� chci zkop�rovat (32bitov� hodnota, v�dy r�zn� od 0)
;   EBX = ukazatel na m�sto, kam chci pole EAX zkop�rovat (32bitov� hodnota, v�dy r�zn� od 0)
;   ECX = po�et prvk� pol� (32bitov� hodnota bez znam�nka, v�dy v�t�� ne� 0)
;
; V�stup:
;   Kopie pole z adresy EAX na adresu EBX.
;
; D�le�it�:
;   Funkce NEmus� zachovat obsah registr�.
;
; Hodnocen�: a� 2 b.
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
