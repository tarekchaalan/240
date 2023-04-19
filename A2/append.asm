;*******************************************************************************************************************************
;                                                                                                                              *
; Program name: "Append Float Array".                                                                                          *
; This program will allow a user to input two float arrays, then it will append them into a third array                        *
; Copyright (C) 2023 Tarek Chaalan.                                                                                            *
;                                                                                                                              *
; This file is part of the software program "Append Float Array".                                                              *
; This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License    *
; version 3 as published by the Free Software Foundation.                                                                      *
; This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied           *
; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.       *
; A copy of the GNU General Public License v3 is available here:  <https:;www.gnu.org/licenses/>.                              *
;                                                                                                                              *
;*******************************************************************************************************************************


;*******************************************************************************************************************************
;                                                                                                                              *
;Author information                                                                                                            *
;  Author name: Tarek Chaalan                                                                                                  *
;  Author email: tchaalan23@csu.fullerton.edu                                                                                  *
;                                                                                                                              *
;*******************************************************************************************************************************


;*******************************************************************************************************************************
;                                                                                                                              *
;Program information                                                                                                           *
;  Program name: Append Float Array                                                                                            *
;  Programming languages: Assembly, C, bash                                                                                    *
;  Date program began: 2023 February 6                                                                                         *
;  Date of last update: 2023 February 21                                                                                       *
;  Date of reorganization of comments: 2023 February 21                                                                        *
;  Files in this program: main.c, manager.asm, display_array.c, magnitude.asm, append.asm, input_array.asm                     *
;  Status: Finished.  The program was tested extensively with no errors in WSL2.0: Ubuntu 20.04.                               *
;                                                                                                                              *
;*******************************************************************************************************************************


;*******************************************************************************************************************************
;                                                                                                                              *
;This file                                                                                                                     *
;   File name: append.asm                                                                                                      *
;   Language: x86 with Intel Syntax                                                                                            *
;   Max page width: 134 columns                                                                                                *
;   Compile: nasm -f elf64 -l append.lis -o append.o append.asm                                                                *
;   Link: gcc -m64 -no-pie -o addFloatArray.out manager.o input_array.o append.o main.o magnitude.o display_array.o -std=c11   *
;   Purpose: This program appends the two arrays given by the user into a third array                                          *
;                                                                                                                              *
;*******************************************************************************************************************************

global append

extern printf
extern scanf

segment .data
segment .bss
segment .text

append:

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

push qword 0 ;Staying on the boundary

mov r15, rdi ;arr1
mov r14, rsi ;arr2
mov r13, rdx ;arr3
mov r12, rcx ;s1
mov r11, r8  ;s2

;Let user enter numbers until cntrl + d is entered
;This for loop will go to 6, the chosen array size, or end once cntrl d is pressed.
mov r10, 0 ;Loop counter for first and second array
mov r9, 0 ; Loop counter for second array
beginLoop:
  cmp r12, r10 ;We want to exit loop when we hit the size of array (first array)
  je outOfLoop
  movsd xmm15, [r15 + 8*r10]
  movsd [r13 + 8*r10], xmm15
  inc r10  ;Increment loop counter
  jmp beginLoop


outOfLoop:
  cmp r11, r9 ;We want to exit loop when we hit the size of array (second array)
  je endFunction
  movsd xmm15, [r14 + 8*r9]
  movsd [r13 + 8*r10], xmm15
  inc r9   ;Increment loop counter for second array
  inc r10  ;Increment loop counter for both arrays
  jmp outOfLoop
endFunction:

pop rax ;Counter the push at the beginning
mov rax, r10  ;Store the number of elements in the result array (loop counter for both arrays)


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