; Vernamova sifra na architekture DLX
; Ladislav Vašina xvasin11

        .data 0x04          ; zacatek data segmentu v pameti
login:  .asciiz "xvasin11"  ; <-- nahradte vasim loginem
cipher: .space 9 ; sem ukladejte sifrovane znaky (za posledni nezapomente dat 0)

        .align 2            ; dale zarovnavej na ctverice (2^2) bajtu
laddr:  .word login         ; 4B adresa vstupniho textu (pro vypis)
caddr:  .word cipher        ; 4B adresa sifrovaneho retezce (pro vypis)

        .text 0x40          ; adresa zacatku programu v pameti
        .global main        ; 

main:   ; sem doplnte reseni Vernamovy sifry dle specifikace v zadani
;xvasin11-r3-r15-r16-r18-r23-r0
;klic 'va'
;22. pozice pismena 'v' v abecede
;1.  pozice pismena 'a' v abecede

addi r3, r3, 0    		; R3  = 0 COUNTER
addi r16, r16, 96 		; R16 = 96

again:
;------------------------ LICHE pricitam 22 'v'
lb r18, login(r3) 		; R18 = aktualni znak z loginu R3 je index
sgt r15, r18, r16 		; kontrola zda nacitany znak je male pismeno (ASCII>96)  if r18>r16(96) then r15=1(continue) else r15 = 0(end)
beqz r15, stringEnd		; pokud neni splnena podminka, ze ASCII hodnota znaku je < 96
nop
nop

addi r16, r0, 122		; R16 = 122 - pozice znaku 'z' v ASCII
addi r18, r18, 22		; R18 = R18 + 22 'v' - pocet pozic o ktere posouvame liche znaky
sgt r15, r18, r16		; kontrola zda jsme pretekli abecedu 122    if r18>r16(122) then r15=1(overflow) else r15 = 0(OK)
beqz r15, notOverflow
nop
nop

subi r18, r18, 26		; OSETRENI OVERFLOW

j okLiche
nop
nop

notOverflow:
sb cipher(r3), r18              ; uloz do vysledku dany znak
okLiche:
sb cipher(r3), r18              ; uloz do vysledku dany znak


addi r15, r0, 1 		; navraceni stavu continue/end FLAGU
addi r16, r0, 96		; R = 96 navraceni hodnoty pro kontrolu rozsahu znaku
addi r3, r3, 1			; inkrementace counteru

;------------------------ SUDE odcitam 1 'a'
lb r18, login(r3) 		; R18 = aktualni znak z loginu R3 je index
sgt r15, r18, r16 		; kontrola zda nacitany znak je male pismeno (ASCII>96)  if r18>r16(96) then r15=1(continue) else r15 = 0(end)
beqz r15, stringEnd		; pokud neni splnena podminka, ze ASCII hodnota znaku je < 96
nop
nop

addi r16, r0, 97		; R16 = 97 - pozice znaku 'a' v ASCII
subi r18, r18, 1		; R18 = R18 - 1 'a' - pocet pozic o ktere posouvame sude znaky
slt r15, r18, r16		; kontrola zda jsme podtekli abecedu 97   if r18<r16(97) then r15=1(underflow) else r15 = 0(OK)
beqz r15, notUnderflow
nop
nop

addi r18, r18, 26		; OSETRENI UNDERFLOW

j okSude
nop
nop

notUnderflow:
sb cipher(r3), r18              ; uloz do vysledku dany znak
okSude:
sb cipher(r3), r18              ; uloz do vysledku dany znak

addi r15, r0, 1 		; navraceni stavu continue/end FLAGU
addi r16, r0, 96		; R = 96 navraceni hodnoty pro kontrolu rozsahu znaku
addi r3, r3, 1                  ; inkrementace counteru
j again

stringEnd:
addi r18, r0, 0
sb cipher(r3), r18 
end:    addi r14, r0, caddr ; <-- pro vypis sifry nahradte laddr adresou caddr
        trap 5  ; vypis textoveho retezce (jeho adresa se ocekava v r14)
        trap 0  ; ukonceni simulace
