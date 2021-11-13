%include "Rw32-2020.inc"

; Naprogramujte funkci "task11", kter� zam�n� po�ad� slabik (byt�) X1, X2, X3, X4 v registru EAX takto:
;
; p�vodn� hodnota:  EAX = X4 X3 X2 X1
; v�sledn� hodnota: EAX = X3 X1 X4 X2 
;
; Funkci je hodnota p�ed�na v resgistru EAX a v�sledek vrac� tak� v registru EAX. Nejni��� v�znamov�
; slabika (byte) je X1, nejvy��� v�znamov� slabika (byte) je X4.
;
; Vstup:
;    - EAX = 32bitov� hodnota
;
; V�stup:
;    - EAX = v�sledek
;    - funkce nemus� zachovat obsah registr�
;
section .data

	; moje data
 
section .text
 
CMAIN:
        push ebp
        mov ebp,esp
        mov eax, 0xDDCCBBAA
        task11:
        

        xchg al,ah ; x4 x3 x1 x2
        rol eax,8 ;  x3 x1 x2 x4
        xchg al,ah ; x3,x1,x4,x2 
       
       
        mov eax, 0xDDCCBBAA ;chci vysledek X1 X3 X2 X4  
        rol eax, 16
        xchg ah, al
        rol eax, 8
        xchg ah, al
        ; neboli AA CC BB DD  X1 X3 X2 X4
        ret
 
        pop ebp	
	ret