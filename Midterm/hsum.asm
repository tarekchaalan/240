;*******************************************************************************************************************************
;                                                                                                                              *
; Author Name: Tarek Chaalan                                                                                                   *
; Author Email: tchaalan23@csu.fullerton.edu                                                                                   *
; Course & Section: CPSC240-3                                                                                                  *
; Todays Date: March 22, 2023                                                                                                  *
;                                                                                                                              *
;*******************************************************************************************************************************

global hsum

segment .data
segment .bss  ;Reserved for uninitialized data
segment .text ;Reserved for executing instructions.

hsum:

;Prolog ===== Insurance for any caller of this assembly module ========================================================
;Any future program calling this module that the data in the caller's GPRs will not be modified.
push rbp
mov  rbp,rsp
push rdi                                                    ;Backup rdi
push rsi                                                    ;Backup rsi
push rdx                                                    ;Backup rdx
push rcx                                                    ;Backup rcx
push r8                                                     ;Backup r8
push r9                                                     ;Backup r9
push r10                                                    ;Backup r10
push r11                                                    ;Backup r11
push r12                                                    ;Backup r12
push r13                                                    ;Backup r13
push r14                                                    ;Backup r14
push r15                                                    ;Backup r15
push rbx                                                    ;Backup rbx
pushf                                                       ;Backup rflags

push qword 0 ;Remain on the boundary
;Taking information from parameters
mov r15, rdi ;This holds the first parameter (the array)
mov r14, rsi ;This holds the second parameter (the number of elements in the array, not size)

;Harmonic sum = 1/a + 1/b + 1/c + 1/d + ...

mov rax, 1 ; one xmm register will be used
mov rdx, 0
cvtsi2sd xmm15, rdx ; convert the 0 in rdx to something xmm can read
mov rdx, 1
cvtsi2sd xmm13, rdx ; convert the 1 in rdx to something xmm can read
mov r13, 0 ; for loop counter goes up to r14, starting at 0
beginLoop:
  cmp r13, r14  ;comparing increment with r14 (the size of array)
  je outOfLoop
  movsd xmm14, [r15 + 8*r13] ;move the value at array[counter] to xmm14
  divsd xmm13, xmm14 ;divide the numerator by the value at array[counter]
  addsd xmm15, xmm13 ;add to xmm15 (1.0 / array[counter])
  inc r13  ;increment loop counter
  jmp beginLoop
outOfLoop:


pop rax ;push counter at the beginning

movsd xmm0, xmm15 ; returning sum to caller

;===== Restore original values to integer registers ===================================================================
popf                                                        ;Restore rflags
pop rbx                                                     ;Restore rbx
pop r15                                                     ;Restore r15
pop r14                                                     ;Restore r14
pop r13                                                     ;Restore r13
pop r12                                                     ;Restore r12
pop r11                                                     ;Restore r11
pop r10                                                     ;Restore r10
pop r9                                                      ;Restore r9
pop r8                                                      ;Restore r8
pop rcx                                                     ;Restore rcx
pop rdx                                                     ;Restore rdx
pop rsi                                                     ;Restore rsi
pop rdi                                                     ;Restore rdi
pop rbp                                                     ;Restore rbp

ret