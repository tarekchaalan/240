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
;   File name: input_array.asm                                                                                                 *
;   Language: x86 with Intel Syntax                                                                                            *
;   Max page width: 134 columns                                                                                                *
;   Compile: nasm -f elf64 -l input_array.lis -o input_array.o input_array.asm                                                 *
;   Link: gcc -m64 -no-pie -o addFloatArray.out manager.o input_array.o append.o main.o magnitude.o display_array.o -std=c11   *
;   Purpose: Defines the "input_array" function, which reads user input into a float array and returns the size of the array   *
;            to the caller module.                                                                                             *
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