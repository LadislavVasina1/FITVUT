%include "rw32-2018.inc"

section .data

    array_a dw 0,0xFFFF,1,2,3,4
    array_b db 0,1,5,0xFF,16,5
    
    array16b dw 0,1,2,3,4,5
    array32b dd 6,7,8,9,10,11
    
    pole1 dw 10,20,30,40,50,60,70,80,90,100
    pole2 dw 5,10,15,20,25,30,35,40,45,50
    
    a db 00
    b db 10
    c db 20
    d db 30
    array_p dd a,b,c,d
    
    
section .text
_main:
    push ebp
    mov ebp, esp
;*************************************************************************************    

    ; binarni hodnota - 0bXXXXXXX, 
    ; hexadecimalni 0xXXX, 
    ; kde X je pozadovana hodnotu v dane ciselne soustave

    ; CF - pokud dojde k prenosu z MSB: 0b11111111 + 0b1 -> CF
    ; ZF - pokud je vysledek aritmeticke operace 0 (instrukce sub, add, (mul, div))
    ; OF - 0b01111111 - +127 pokud pricteme +0b1 -> -128
    ; PF - pokud je pocet 1 sudy (0,2,4,6,8,...)
    
 ;************************************************************************************  
  
    ; Vygenerovni AF, ZF, PF bez pristupu do pameti 
    ;mov al, 0b11111111
    ;add al, 1
    
    ;mov bl, 0b01111111
    ;add bl, 1

;**********************************************************************************************  
 
    ; Vygenerujte priznak CF s pouzitim 1. prvku (prvek s indexem 1) pole array_a,
    ; kde jednotlive polozky maji 16 bitu a 3. prvkem (prvek sindexem 3) pole array_b, ktere obsahuje 8 bitove prvky.
    
            ;[pole   +  index * velikost v B]
            ;EA = base + index * scaling_factor + displacement
    mov ax, [array_a + 1*2]
    add ax, [array_b + 3*1]
    
 ;****************************************************************************************   
    ;Dat prvky na sudem indexu pole 1 misto prvku na sudem indexu v poli 2
    xor eax, eax
    mov eax, [array16b + 0*2]
    mov [array32b + 0*4], ax
    
    xor ebx, ebx
    mov ebx, [array16b + 2*2]
    mov [array32b + 2*4], bx
    
    xor ecx, ecx
    mov ecx, [array16b + 4*2]
    mov [array32b + 4*4], cx
    
;*************************************************************************************** 
  ; Vygeneruj pomoci ADD a SUB priznaky ZF, SF, CF, PF, AF. Pouzij 16b registry
    mov al, 0x7F
    add al, 10 

;***************************************************************************************  
;Vytvorte si dve pole o velikosti 10 prvku. Nasledne provedte vypocet pole1[i]-pole1[i]+pole2[i]-4  i=0..9

mov ecx, 10
cyklus: ; odecita 1 z ecx dokud je hodnota ecx > 0
    xor eax, eax
    add ax, [pole1 + ecx*2-2] ; kdyz bude al/ah odectes 1 (jako 1B). Kdyz bude eax tak odectes 4 (jako 4B)
    add ax, [pole2 + ecx*2-2]
    sub ax, word 4 ; pricte 16b hodnotu 4
    mov [pole1+ecx*2-2], ax
    
loop cyklus

;***************************************************************************************
;Vytvorte pole a,b,c,d o libovolnem poctu prvku. Nasledne vytvorte pole p_array s ukazateli na pole a,b,c,d. Vypiste posledni prvek pole c pomoci p_array
    
    xor eax, eax
    mov edx, [array_p + 2*4]
    mov al, [edx]

    pop ebp
    ret