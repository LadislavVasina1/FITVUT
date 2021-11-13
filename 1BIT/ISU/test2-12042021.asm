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
;--- Úkol 1 ---
;
; Naprogramujte funkci 'task21', která porovná prvky polí 32bitových hodnot bez znaménka. Ukazatel na první pole
; je v registru EAX, ukazatel na druhé pole je v registru EBX a poèet prvkù obou polí je v registru ECX.
;
; Parametry funkce:
;   EAX = ukazatel na první pole 32bitových hodnot bez znaménka (EAX je vždy platný ukazatel)
;   EBX = ukazatel na druhé pole 32bitových hodnot bez znaménka (EBX je vždy platný ukazatel)
;   ECX = poèet prvkù polí (32bitová hodnota bez znaménka, vždy vìtší než 0)
;
; Návratová hodnota:
;   EAX = 1, pokud obì pole obsahují stejné hodnoty, jinak EAX = 0
;
; Dùležité:
;   - funkce nemusí zachovat obsah registrù
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
;--- Úkol 2 ---
;
; Naprogramujte funkci: int task22(const unsigned int *pA, int N, unsigned int x), která v poli 32bitových èísel bez znaménka pA
; spoèítá výskyt všech prvkù pole stejných jako je hodnota x. Délka pole je dána parametrem N. 
; Funkce dostává parametry, uklízí zásobník a vrací výsledek podle konvence STDCALL.
;
; Parametry funkce:
;   pA: ukazatel na pole A (pole obsahuje 32bitové hodnoty bez znaménka)
;    N: poèet prvkù pole A (32bitové èíslo se znaménkem)
;    x: porovnávaná hodnota
;
; Návratová hodnota:
;   EAX = -1, když je pA neplatný ukazatel (pA == 0) nebo N < 0
;   EAX = poèet prvkù pole stejných jako x
;
; Dùležité:
;   - funkce MUSÍ zachovat obsah všech registrù, kromì registru EAX a pøíznakového registru.
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
;--- Úkol 3 ---
;
; Naprogramujte funkci 'task23', která alokuje a naplní pole 16bitových celých èísel bez znaménka Fibonacciho èísly
; F(0), F(1), ... , F(N-1). Požadovaný poèet Fibonacciho èísel je uveden v registru ECX (32bitová hodnota se znaménkem)
; a funkce vrací v EAX ukazatel na pole, které alokuje funkcí 'malloc' ze standardní knihovny jazyka C.
;
; Fibonacciho èísla jsou definována takto:
;
;   F(0) = 0
;   F(1) = 1
;   F(n) = F(n-1) + F(n-2)
;
; Vstup:
;   ECX = požadovaný poèet prvkù pole (32bitové celé èíslo se znaménkem).
;
; Výstup:
;   EAX = 0, pokud N <= 0, nic nealokujete a vrátíte hodnotu 0 (NULL),
;   EAX = 0, pokud došlo k chybì pøi alokování pamìti funkcí 'malloc' (vrátí hodnotu 0),
;   EAX = ukazatel na pole 16bitových celoèíselných prvkù bez znaménka reprezentujících Fibonacciho èísla.
;
; Dùležité:
;   - funkce musí zachovat obsah všech registrù, kromì registru EAX a pøíznakového registru,
;   - funkce 'malloc' mùže zmìnit obsah registrù ECX a EDX.
;
; Funkce 'malloc' je definována takto: 
;
;   void* malloc(size_t N)
;     N = poèet bytù, které mají být alokovány (32bitové celé èíslo bez znaménka),
;     - funkce vrací v EAX ukazatel (32bitové celé èíslo bez znaménka) na alokované místo v pamìti,
;     - funkce vrací v EAX hodnotu 0 (NULL) v pøípadì chyby pøi alokování pamìti,
;     - funkce mùže zmìnit obsah registrù ECX a EDX.
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
