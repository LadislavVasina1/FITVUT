%include "rw32-2020.inc"
extern _malloc

section .data
    task21A dd 6144,5632,256,4864,2304,3584,12032,12032
    task21B dd 6144,5632,256,4864,2304,3584,12032,12032
    task22A dd 6144,5632,256,4864,2304,3584,12032,12032
    task22B dd 1942744623,2803163407,1532126890,1242444721,1298680726,3727059845,656499002,52669266
    task23A dw 384,352,16,304,144,224,-752,-752

section .text
CMAIN:
    push ebp
    mov ebp,esp
     
    mov eax,task21A ; Ukazatel na prvni pole
    mov ebx,task21B ; Ukazatel na druhe pole
    mov ecx,8 ; Pocet prvku obou poli 
    call task21

    
    ; eax = task22(task22A,8,0)
    push dword[task22A]
    push dword 8
    push dword 0
    call task22    
          
    mov ecx,8
    push ecx
    call task23

    pop ebp
    ret    
;
;--- �kol 1 ---
;
; Naprogramujte funkci 'task21', kter� porovn� prvky pol� 32bitov�ch hodnot bez znam�nka. Ukazatel na prvn� pole
; je v registru EAX, ukazatel na druh� pole je v registru EBX a po�et prvk� obou pol� je v registru ECX.
;
; Parametry funkce:
;   EAX = ukazatel na prvn� pole 32bitov�ch hodnot bez znam�nka (EAX je v�dy platn� ukazatel)
;   EBX = ukazatel na druh� pole 32bitov�ch hodnot bez znam�nka (EBX je v�dy platn� ukazatel)
;   ECX = po�et prvk� pol� (32bitov� hodnota bez znam�nka, v�dy v�t�� ne� 0)
;
; N�vratov� hodnota:
;   EAX = 1, pokud ob� pole obsahuj� stejn� hodnoty, jinak EAX = 0
;
; D�le�it�:
;   - funkce nemus� zachovat obsah registr�
;
task21:  
dec ecx

for:
mov edx, dword[eax + ecx*4]
cmp edx, dword[ebx + ecx*4]
jne notEq

dec ecx
cmp ecx, -1
jne for

mov eax, 1
jmp end

notEq:
mov eax, 0

end:

ret
;
;--- �kol 2 ---
;
; Naprogramujte funkci: int task22(const unsigned int *pA, int N, unsigned int x), kter� v poli 32bitov�ch ��sel bez znam�nka pA
; spo��t� v�skyt v�ech prvk� pole stejn�ch jako je hodnota x. D�lka pole je d�na parametrem N. 
; Funkce dost�v� parametry, ukl�z� z�sobn�k a vrac� v�sledek podle konvence STDCALL.
;
; Parametry funkce:
;   pA: ukazatel na pole A (pole obsahuje 32bitov� hodnoty bez znam�nka)
;    N: po�et prvk� pole A (32bitov� ��slo se znam�nkem)
;    x: porovn�van� hodnota
;
; N�vratov� hodnota:
;   EAX = -1, kdy� je pA neplatn� ukazatel (pA == 0) nebo N < 0
;   EAX = po�et prvk� pole stejn�ch jako x
;
; D�le�it�:
;   - funkce MUS� zachovat obsah v�ech registr�, krom� registru EAX a p��znakov�ho registru.
;
task22:
;    push ebp
;    mov ebp, esp
;    
;    push ebx
;    push ecx
;    push edx
;    
;    mov ebx, [ebp+8]  ;unsigned int x (pocet prvku)
;    mov ecx, [ebp+12] ;int N (delka pole)
;    mov edx, [ebp+16] ;const unsigned int *pA
;    
;    mov eax, 0
;
;    cmp ebx, 0
;    je fault
;
;    cmp ecx, 0
;    jl fault
;
;    dec ecx
;    for:
;    cmp dword [ebx+ecx*4], edx
;    jne skip
;    inc eax
;    skip:
;    dec ecx
;    cmp ecx, -1
;    jne for
; 
;    jmp end
;    fault:
;    mov eax, -1
;    end: 
;    
;    pop edx
;    pop ecx
;    pop ebx
;    
;    mov esp, ebp
;    push ebp
;    ret 12 ; 3 parametry
;
;--- �kol 3 ---
;
; Naprogramujte funkci 'task23', kter� alokuje a napln� pole 16bitov�ch cel�ch ��sel bez znam�nka Fibonacciho ��sly
; F(0), F(1), ... , F(N-1). Po�adovan� po�et Fibonacciho ��sel je uveden v registru ECX (32bitov� hodnota se znam�nkem)
; a funkce vrac� v EAX ukazatel na pole, kter� alokuje funkc� 'malloc' ze standardn� knihovny jazyka C.
;
; Fibonacciho ��sla jsou definov�na takto:
;
;   F(0) = 0
;   F(1) = 1
;   F(n) = F(n-1) + F(n-2)
;
; Vstup:
;   ECX = po�adovan� po�et prvk� pole (32bitov� cel� ��slo se znam�nkem).
;
; V�stup:
;   EAX = 0, pokud N <= 0, nic nealokujete a vr�t�te hodnotu 0 (NULL),
;   EAX = 0, pokud do�lo k chyb� p�i alokov�n� pam�ti funkc� 'malloc' (vr�t� hodnotu 0),
;   EAX = ukazatel na pole 16bitov�ch celo��seln�ch prvk� bez znam�nka reprezentuj�c�ch Fibonacciho ��sla.
;
; D�le�it�:
;   - funkce mus� zachovat obsah v�ech registr�, krom� registru EAX a p��znakov�ho registru,
;   - funkce 'malloc' m��e zm�nit obsah registr� ECX a EDX.
;
; Funkce 'malloc' je definov�na takto: 
;
;   void* malloc(size_t N)
;     N = po�et byt�, kter� maj� b�t alokov�ny (32bitov� cel� ��slo bez znam�nka),
;     - funkce vrac� v EAX ukazatel (32bitov� cel� ��slo bez znam�nka) na alokovan� m�sto v pam�ti,
;     - funkce vrac� v EAX hodnotu 0 (NULL) v p��pad� chyby p�i alokov�n� pam�ti,
;     - funkce m��e zm�nit obsah registr� ECX a EDX.
task23:
    push ebp
    mov ebp, esp
    
    cmp ecx, 0
    jle wrongN 
    
    push ecx
    call _malloc
    add esp, 4
    
    cmp eax, 0
    je wrongN
    
    wrongN:
    mov eax, 0
    
    mov esp, ebp
    push ebp
    ret
