%include "rw32-2020.inc"

section .data    
    a dd 1.5,-100.5,30000.300,-434.434,0.0,1.0,-1.0,0.0001,1.5,200.75
    sortError dd -1    
       
section .text
CMAIN:
    push ebp
    mov ebp,esp
    
    mov ecx,10
    mov esi,a
    mov edi,sortError
    call task31
    
    push __float32__(10.550)
    ;push __float32__(1.5)
    push __float32__(15.550)
    call task32
    add esp,8

    mov esp,ebp
    pop ebp
    ret    
;
;--- Task 1 --- 
;
; Create a function 'task31' to sort an array of float elements (IEEE754 single precision 32bit floating point values) 
; in ascending order (from the lowest to the highest) using the 'qsort' function from the standard C library.
;
; Function parameters:`
;   ECX = count of the elements in the array (32bit signed integer),
;   ESI = pointer to the array of the IEEE754 single precision 32bit floating point values (float),
;   EDI = pointer to the 32bit signed integer or NULL.
;
; Return values:   
;   ZF = 0 if ESI == 0 or ECX <= 0 (i.e. you CLEAR the Zero Flag just before the return from the function),
;   ZF = 1 in all other cases (i.e. you SET the Zero Flag just before the return from the function),
;   if EDI != NULL (i.e. EDI != 0), store the following value at the address in EDI:
;       [EDI] = 1, if ESI == 0,
;       [EDI] = 2, if ECX <= 0,
;       [EDI] = 3, if ESI == 0 and ECX <= 0,
;       [EDI] = 0, in all other cases.
;
; Important:
;   - the function MUST preserve content of all the registers except for the EAX and flags registers,
;   - the 'qsort' function may change the content of the ECX and EDX registers,
;   - you are not allowed to use the following FPU instructions: FINIT, FNINIT, FCLEX, FNCLEX, FFREE, FINCSTP, FDECSTP, 
;     FLDCW, FLDENV, FRSTOR, FXRSTOR.
;
; To solve this task you have to use the 'qsort' function from the standard C library (CDECL calling convention),
; which is declared as follows:
;
;   void qsortd ( voi*ptr, size_t count, size_t size, int (*comp)(const void *, const void *) ).
;
; This function sorts the 'count' elements of the array pointed to by 'ptr', each element is 'size' bytes long,
; using the 'comp' function to determine the order. In order to compare two values, the 'qsort' function calls
; the function 'comp', which you have to create, too. The 'comp' function is declared as (CDECL calling convention):
;
;   int comp(const void *ptrA, const void *ptrB).
;
; The 'comp' function compares two elements pointed to by the 'ptrA' and 'ptrB' pointers and defines the order of   
; the two elements this way:
;
;    -1 (or any other negative value) <=> *ptrA goes before *ptrB,
;     0 <=> *ptrA is same as *ptrB,
;     1 (or any other positive value) <=> *ptrA goes after *ptrB.
task31:
    ; insert your code here
    ret
;
;--- Task 2 ---
;
; Create a function: float task32(float x, float y) to evaluate the function f(x,y) for the given input (x, y)
; using FPU. The function returns the result of the evaluation in the ST0 FPU register. The function receives its 
; parameters x, y on the stack in order from the last to the first, the stack is cleared by the caller and the 
; result is returned in the ST0 FPU register (CDECL calling convention). The function f(x,y) is defined as follows:
;
;
;           A      sqrt(y + 7.550) * cos(y + pi*x)
; f(x,y) = --- = ---------------------------------------------
;           B              abs(y + x/4)
;
;
; Function parameters:
;        x: IEEE754 single precision 32bit floating point number (float),
;        y: IEEE754 single precision 32bit floating point number (float),
;
; Return values:
;   - ST0 = f(x,y) if (x, y) ∈ D(f) (~ the function f(x,y) can be evaluated),
;   - ST0 = QNaN (Quiet Not a Number) if (x, y) ∉ D(f) (~ the function f(x,y) can not be evaluated).
;
; Important:
;   - you are not allowed to use the following FPU instructions: FINIT, FNINIT, FCLEX, FNCLEX, FFREE, FINCSTP, FDECSTP, 
;     FLDCW, FLDENV, FRSTOR, FXRSTOR,
;   - assume that the FPU has already been initialized by the FINIT instruction,
;   - the function MUST preserve content of all the registers except for the EAX and flags registers,
;   - the function MUST empty the FPU stack except for the ST0 register, in which the function returns its result.

;
;           A      sqrt(y + 7.550) * cos(y + pi*x)
; f(x,y) = --- = ---------------------------------------------
;           B              abs(y + x/4)
;
task32:
    push ebp
    mov ebp, esp
    
    fld dword [ebp+8]  ;x
    fldpi  
    fmul
    ;st0 pi*x
    fld dword [ebp+12] ;y
    fadd
    fcos     ; cos(y + pi*x)
    push __float32__(7.550)   ; pushnuti konstanty na esp
    fld dword [esp]
    fld dword [ebp+12]
    
    fcomi st0, st1
    jb fail
    
    fadd
       
    fsqrt
    fmul
    
    fld dword [ebp+8]
    push __float32__(4.0)   ; pushnuti konstanty na esp
    fld dword [esp]
    fdiv
    fld dword [ebp+12]
    fadd
    fabs  
    
    fldz
    fcomip
    je fail
                                                                                                         
    fdiv
    jmp skip
    
    fail:
    fstp st0
    fstp st0    
    fldz
    fldz
    push dword 0xffffffff
    fld  dword [esp]
    jmp end
    
    skip:
    fldz
    fstp st0
    
    end:
    mov esp, ebp
    pop ebp
    
    ret
