%include "rw32-2018.inc"
extern _qsort
section .data
    str1 db "Ahoj" ; delka 4
    str2 db "FIT Ahoj FIT" ; delka 12
    
    array_sort1 dw 10,10002,200,500,300,400
    
section .text


;fce1(char * p1, int * p2)
; pokud p1 == null --> EAX=0
; pokud p2 == null --> EAX=1
; zachovejte obsah puvodnich registru
;fce1:
;    push ebp
;    mov ebp, esp
    
;    mov ebx, [ebp+8]
;    mov ecx, [ebp+12]
    
;    cmp ebx, 0
;    jz
    
    
    
;int values[] = { 40, 10, 100, 90, 20, 25 };

;int compare (const void * a, const void * b)
;{
;  return ( *(int*)a - *(int*)b );
;}

;int main ()
;{
;  int n;
;  qsort (values, 6, sizeof(int), compare);
;  for (n=0; n<6; n++)
;     printf ("%d ",values[n]);
;  return 0;
;}
    
;    chyba1:
;        mov eax, 0
;        jmp konec_fce
;    chuba2:
;        mov eax, 1
        
;    konec_fce:
        
;    mov esp, ebp
;    pop ebp
;    ret 


compare:
    push ebp
    mov ebp, esp
    
    push ebx ;ULOZENI REGISTRU - KDYZ BUDE V ZADANI NEZMENTE HODNOTY REGISTRU
    push edx ;ULOZENI REGISTRU - KDYZ BUDE V ZADANI NEZMENTE HODNOTY REGISTRU
    
    mov eax, [ebp + 8] ;addr b
    mov ebx, [ebp + 12];addr a
    
    mov dx, [ebx]
    
    sub dx, [eax]
               
    xor eax, eax
    mov ax, dx
    cwde
    
    pop edx ;TOTO TAKY NAPSAT - KDYZ BUDE V ZADANI NEZMENTE HODNOTY REGISTRU
    pop ebx ;TOTO TAKY NAPSAT - KDYZ BUDE V ZADANI NEZMENTE HODNOTY REGISTRU
    
    mov esp, ebp
    pop ebp
    ret

_main:
    push ebp
    mov ebp, esp
    
    push compare
    push dword 2
    push dword 6
    push array_sort1
    call _qsort
    add esp, 16 ; 4*4
    
    
    ;mov edx, 8 ;12-4
    ;mov ebx, 0
      
          
;cyklus:
;    mov esi, str1
;    lea edi, [str2+ebx]
   
;    mov ecx, 4
;    repz cmpsb
;    jz stejne
;    jmp else
;stejne:    mov al, 'x'
;    lea edi, [str2+ebx]
;    mov ecx, 4
;    rep stosb
;else: 

;    inc ebx
;    cmp ebx, edx
;    jnz cyklus
    
    pop ebp
    ret