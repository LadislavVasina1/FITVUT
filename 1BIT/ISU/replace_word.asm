; Nazev prikladu: Nahrazeni vyhledaneho slova v retezci pismeny x
; Pokud pouzivate SASM musite vstupy napsat predem a oddelit entrem
; Spatny format neni osetreny
; Autor: Tomas Goldmann

%include "rw32-2020.inc"

section .bss

string1 resb 101
word1 resb 31

section .data

section .text


;nahradi hledane slovo v retezci pismeny x
replace:
	push ebp
	mov ebp, esp

	mov ecx, [ebp+12]
	sub ecx, [ebp+8]
	inc ecx

	xor edx,edx
	cmp ecx, edx
	je skip_cycle

cycle:
	mov esi, [ebp+16]
	mov edi, [ebp+20]
	add edi, edx
	push ecx
	mov ecx, [ebp+8]
	repz cmpsb
	pop ecx
	jnz skip

	sub edi,[ebp+8]
	mov al, 'x'
	push ecx
	mov ecx,[ebp+8]
	rep stosb
	pop ecx

	skip:

	inc edx
	cmp ecx,edx
	jne cycle
skip_cycle:


	mov esp, ebp
	pop ebp
	ret 16

main:

 	xor eax,eax

	;nacteni retezce z stdin
	mov edi, string1
	mov ebx, 100
	call ReadString
	mov ecx, eax

	;nacteni slova z stdin
	mov edi, word1
	mov ebx, 30
	call ReadString
	mov edx, eax

	;volani funkce
	mov eax, string1
	push eax
	mov eax, word1
	push eax
	push ecx
	push edx
	pushad
	call replace
	popad

	;vypsani na stdout
	mov esi, string1
	call WriteString

ret
