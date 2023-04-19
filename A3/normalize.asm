;*******************************************************************************************************************************
;                                                                                                                              *
; Program name: "Non-deterministic Random Numbers".                                                                            *
; The program is designed to produce a up to 100 random numbers based on user input and then store these values in             *
; an array. The generated random numbers will be printed in both IEEE754 and scientific decimal format. Additionally, the      *
; array will be sorted in ascending order and normalized to fall within the range of 1.0 to 2.0. The array will be printed in  *
; its original, sorted, and normalized states, all in both IEEE754 and scientific decimal formats.                             *
;                                                                                                                              *
; Copyright (C) 2023 Tarek Chaalan.                                                                                            *
;                                                                                                                              *
; This file is part of the software program "Non-deterministic Random Numbers".                                                *
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
;  Program name: Non-deterministic Random Numbers                                                                              *
;  Programming languages: Assembly, C, C++, bash                                                                               *
;  Date program began: 2023 March 5                                                                                            *
;  Date program is due: 2023 March 13                                                                                          *
;  Date of last update: 2023 March 13                                                                                          *
;  Files in this program: main.cpp, quick_sort.c, executive.asm, fill_random_array.asm,                                        *
;                         isnan.asm, show_array.asm normalioze.asm                                                             *
;  Status: Finished.  The program was tested extensively with no errors in WSL2.0: Ubuntu 20.04.                               *
;                                                                                                                              *
;*******************************************************************************************************************************


;*******************************************************************************************************************************
;                                                                                                                              *
;This file                                                                                                                     *
;   File name: normalize.asm                                                                                                   *
;   Language: x86 with Intel Syntax                                                                                            *
;   Max page width: 134 columns                                                                                                *
;   Compile: nasm -f elf64 -l normalize.lis -o normalize.o normalize.asm								                       *
;   Link: g++ -m64 -std=c++17 -fno-pie -no-pie -o assignment3.out main.o executive.o fill_random_array.o show_array.o          *
;         quick_sort.o normalize.o isnan.o                                                                                     *
;   Purpose: This Program normalizes the 64-bit random numbers generated by rdrand and stored in an array so that they fall    *
;            within the range of 1.0 to 2.0.                                                                                   *
;                                                                                                                              *
;*******************************************************************************************************************************

global normalize

segment .data

segment .bss

segment .text

normalize:                 ;start execution of program

;Prolog ===== Insurance for any caller of this assembly module ============================================================================================================
;Any future program calling this module that the data in the caller's GPRs will not be modified.
push rbp                                                    ;Push memory address of base of previous stack frame onto stack top
mov  rbp,rsp                                                ;Copy value of stack pointer into base pointer, rbp = rsp = both point to stack top
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

mov r13, rdi    ;r13 now stores the array
mov r14, rsi    ;r14 now stores the size of array
mov r15, 0      ;counter for loop

;normalize all the random numbers in the array 
beginLoop:                  ;start of loop
    cmp r15, r14            ;compare counter with size of array
    je exitLoop             ;if counter already equal size of array, exit the loop
    mov r12, [r13 + 8*r15]  ;move the random number stored in a specific location of the array to r12
    shl r12, 12             ;shift left r12 by 12 so now r12 have mantissa followed by trailing zeros
    shr r12, 12             ;shift right r12 by 12 so now r12 have 12 zeros infront followed by the mantissa
    mov rbx, 1023           ;rbx now contains 3FF. 3FF is a number between 1.0<=num<2.0
    shl rbx, 52             ;shift left rbx by 52 so that it has 3FF infront followed by trailing zeros
    or r12, rbx             ;merge r12 and rbx together so that it forms a complete IEEE754 number between 1.0<=num<2.0
    mov [r13 + 8*r15], r12  ;move r12 back into the same specific location in the array to replace the old number with the new normalized number
    inc r15                 ;increment counter to repeat until all numbers in the array are normalized
    jmp beginLoop           ;jump to start of loop
exitLoop:                   ;if done, exit the loop here

;Restore original values to integer registers 
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