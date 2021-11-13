%include "rw32-2018.inc"
section .data
    task21A dd 3072,-1024,768,1536,512,-768,-15104,-13824
    task21B dd 1430887681,-701210901,-802797689,-1658204169,-1073467232,706416762,-1178549399,-2074456426
    task22A dw 192,-64,48,96,32,-48,-944,-864
    task22B dw 18734,-28251,-10526,-9352,22250,9242,-2652,30871
    task23A dd 6144,2048,3840,4608,3584,2304,-12032,-10752

section .text
CMAIN:
    push ebp
    mov ebp,esp
    
    mov eax,task21A
    mov ebx,task21B
    mov ecx,8
    call task21
       
    
    call task22

    
    mov edi,task23A
    mov ecx,8
    call task23

    pop ebp
    ret    
;           
;--- Úkol 1 --- 
;
; Naprogramujte funkci, která zkopíruje pole 32bitových hodnot z pole, na které
; ukazuje registr EAX do pole, na který ukazuje registr EBX. Počet prvků obou polí je v registru ECX.
;
; Vstup:
;   EAX = ukazatel na pole 32bitových hodnot, které chci zkopírovat
;   EBX = ukazatel na místo, kam chci pole EAX zkopírovat
;   ECX = počet prvků polí (32bitová hodnota bez znaménka, vždy větší než 0)
;
; Výstup:
;   Kopie pole z adresy EAX na adresu EBX.
;
; Důležité:
;   Funkce NEmusí zachovat obsah registrů.
;
; Hodnocení: až 2 body.
;
task21:

    ;todo
    ret
;
;
;--- Úkol 2 ---
;
; Naprogramujte funkci, která v poli 16bitových čísel se znaménkem pA nalezne první výskyt 
; hodnoty x a vrátí její pozici. Délka pole je dána parametrem N.
;
; Funkci jsou předávány parametry na zásobníku v pořadí od prvního k poslednímu (zleva doprava), parametry ze 
; zásobníku uklízí volaný a výsledek funkce se vrací v registru EAX (konvence jazyka Pascal).
;
; int task22(const short *pA, int N, short x)
;
; Vstup:
;   pA: ukazatel na pole A (pole A obsahuje 16bitové hodnoty se znaménkem)
;    N: počet prvků pole A (32bitové číslo se znaménkem)
;    x: hodnota, kterou hledáme (16bitové číslo se znaménkem)
;
; Výstup:
;   EAX = index hledaného čísla v poli (prvky pole jsou indexovány od 0)
;   EAX = -1 <=> neplatný ukazatel *pA (tj. pA == 0) nebo N <= 0 nebo hodnota x nebyla v poli nalezena
;
; Důležité:
;   Funkce musí zachovat obsah všech registrů, kromě registru EAX a příznakového registru.
;
; Hodnocení: až 5 bodů.
;
task22:
    ;todo
    ret

;
;--- Úkol 3 ---
;
; Naprogramujte funkci, která vypočítá Fibonacciho posloupnost N čísel. Funkce má jako
; vstupní parametry ukazatel na pole 32bitových čísel bez znaménka v EDI, kam se 
; jednotlivé hodnoty posloupnosti uloží, a počet prvků v ECX (32bitová hodnota
; bez znaménka). Fibonacciho posloupnost je definována takto:
;
;   F(0) = 0
;   F(1) = 1
;   F(n) = F(n-1) + F(n-2)
;
; Algoritmus v jazyce C:
;       
; void fibonacci(unsigned int * pFib, unsigned int N) { 
;   if (N > 0) {
;     pFib[0] = 0;
;     if (N > 1) {
;       pFib[1] = 1;
;       for (int i = 2; i < N; i++) pFib[i] = pFib[i - 1] + pFib[i - 2];      
;     }
;   }
; }
;
; Vstup:
;   EDI: ukazatel na pole 32bitových hodnot bez znaménka
;   ECX: počet prvků pole (32bitové číslo bez znaménka)
;
; Výstup:
;   Na adrese EDI jsou prvky Fibonacciho posloupnosti.
;
; Důležité:
;   Funkce musí zachovat obsah všech registrů, kromě registru EAX a příznakového registru.
;
; Hodnocení: až 5 bodů.
;
task23:
    ;todo
    ret