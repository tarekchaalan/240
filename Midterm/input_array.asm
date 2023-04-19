;*******************************************************************************************************************************
;                                                                                                                              *
; Author Name: Tarek Chaalan                                                                                                   *
; Author Email: tchaalan23@csu.fullerton.edu                                                                                   *
; Course & Section: CPSC240-3                                                                                                  *
; Todays Date: March 22, 2023                                                                                                  *
;                                                                                                                              *
;*******************************************************************************************************************************

global input_array

extern printf
extern scanf
extern stdin
extern clearerr

segment .data
segment .bss  ;Reserved for uninitialized data
segment .text ;Reserved for executing instructions.

float_format db "%lf", 0

input_array:

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

push qword 0  ;Staying on the boundary

;Copy the passed parameters into memory to use
mov r15, rdi  ;r15 holds the array that was passed from parameter list
mov r14, rsi  ;r14 holds the array size


mov r13, 0  ;r13 is a loop counter                                                         
beginLoop:
  cmp r14, r13  ;Exit loop when loop counter is equal to array size
  je outOfLoop
  mov rax, 0
  mov rdi, float_format
  push qword 0
  mov rsi, rsp
  call scanf
  cdqe
  cmp rax, -1  ;Exit loop when user hits ctrl-d
  pop r12
  je outOfLoop
  mov [r15 + 8*r13], r12  ;Place number from scanf into r15 address, and shift 8 bits each for each loop
  inc r13  ;Increment loop counter
  jmp beginLoop
outOfLoop:

;Clears failbit which is necessary in between input_array calls
mov rax, 0
mov rdi, [stdin]
call clearerr

pop rax  ;Counter the push at the beginning
mov rax, r13  ;Return the actual size of the array (loop counter) to caller module

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
