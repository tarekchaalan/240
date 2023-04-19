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
;   File name: manager.asm                                                                                                     *
;   Language: x86 with Intel Syntax                                                                                            *
;   Max page width: 134 columns                                                                                                *
;   Compile: nasm -f elf64 -l manager.lis -o manager.o manager.asm                                                             *
;   Link: gcc -m64 -no-pie -o addFloatArray.out manager.o input_array.o append.o main.o magnitude.o display_array.o -std=c11   *
;   Purpose: This module serves as the main hub to route calls to various functions, such as input_array, display_array,       *
;            magnitude, and append. These functions work together to calculate the magnitude of all elements in a user-defined *
;            array and return it to the caller function in main.c.                                                             *
;                                                                                                                              *
;*******************************************************************************************************************************

global manager

extern printf
extern scanf
extern input_array
extern display_array
extern magnitude
extern append

segment .data

brief db "This program will manage your arrays of 64-bit floats", 10, 0
prompt_a db "For array A enter a sequence of 64-bit floats separated by white space.", 10, 0
prompt_b db 13, 10,"For array B enter a sequence of 64-bit floats separated by white space.", 10, 0
prompt_end db "After the last input press enter followed by Control+D: ", 10, 0
present_numbers_a db 13, 10,"These numbers were received and placed into array A:", 10, 0
present_numbers_b db 13, 10,"These numbers were received and placed into array B:", 10, 0
magnitude_message_a db "The magnitude of array A is %.5lf", 10, 0
magnitude_message_b db "The magnitude of array B is %.5lf", 10, 0
magnitude_message_result db 13, 10,"The magnitude of A⊕ B is %.5lf.", 10, 0
append_message db 13, 10,"Arrays A and B have been appended and given the name A⊕ B", 10, 0
append_message_two db "A⊕ B contains", 10, 0

segment .bss  ;Reserved for uninitialized data
array_one resq 6 ;Array of 6 quad words reserved before run time.
array_two resq 6 
result_array resq 12

segment .text ;Reserved for executing instructions.

manager:


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

push qword 0  ;Remain on the boundary

;"This program will manage your arrays of 64-bit floats"
push qword 0
mov rax, 0
mov rdi, brief
call printf
pop rax

;"For array A enter a sequence of 64-bit floats separated by white space."
push qword 0
mov rax, 0
mov rdi, prompt_a
call printf
pop rax

;"After the last input press enter followed by Control+D: "
push qword 0
mov rax, 0
mov rdi, prompt_end
call printf
pop rax

;Call to input_array function which takes two parameters of array and maxarraysize, and returns actualarraysize
;The input_array function calls scanf to take an input of floats, and terminates on ctrl-d.
;This function takes a parameter of first array
push qword 0
mov rax, 0
mov rdi, array_one ;Array passed in as first param
mov rsi, 6         ;Array size passed in as second param
call input_array
mov r15, rax
pop rax

;"The numbers you entered are these: "
push qword 0
mov rax, 0
mov rdi, present_numbers_a
call printf
pop rax

;Call to display_array module which prints first array
push qword 0
mov rax, 0
mov rdi, array_one
mov rsi, r15
call display_array
pop rax

;Call to magnitude module for first array, storing magnitude in xmm14
;magnitude = sqrt(a^2 + b^2 + c^2 + d ^2 + ...)
push qword 0
mov rax, 0
mov rdi, array_one
mov rsi, r15
call magnitude
movsd xmm14, xmm0
pop rax

;"The magnitude of array A is %.10lf."
push qword 0
mov rax, 1
mov rdi, magnitude_message_a
movsd xmm0, xmm14
call printf
pop rax

;"For array A enter a sequence of 64-bit floats separated by white space."
push qword 0
mov rax, 0
mov rdi, prompt_b
call printf
pop rax

;"After the last input press enter followed by Control+D: "
push qword 0
mov rax, 0
mov rdi, prompt_end
call printf
pop rax

;Call to input_array function which takes two parameters of array and maxarraysize, and returns actualarraysize
;The input_array function calls scanf to take an input of floats, and terminates on ctrl-d.
;This function takes a parameter of second array
push qword 0
mov rax, 0
mov rdi, array_two ; array passed in as first param
mov rsi, 6         ; array size passed in as second param
call input_array
mov r14, rax
pop rax

;"The numbers you entered are these: "
push qword 0
mov rax, 0
mov rdi, present_numbers_b
call printf
pop rax

;Call to display_array module which prints second array
push qword 0
mov rax, 0
mov rdi, array_two
mov rsi, r14
call display_array
pop rax

;Call to magnitude module for second array, storing magnitude in xmm13
;Magnitude = sqrt(a^2 + b^2 + c^2 + d ^2 + ...)
push qword 0
mov rax, 0
mov rdi, array_two
mov rsi, 6
call magnitude
movsd xmm13, xmm0
pop rax


;"The magnitude of array B is %.10lf."
push qword 0
mov rax, 1
mov rdi, magnitude_message_b
movsd xmm0, xmm13
call printf
pop rax

;Call to append module which appends the second array to the first array, and stores it in a result array
push qword 0
mov rax, 0
mov rdi, array_one
mov rsi, array_two
mov rdx, result_array
mov rcx, r15
mov r8, r14
call append
pop rax

;"Arrays A and B have been appended and given the name A⊕ B"
push qword 0
mov rax, 0
mov rdi, append_message
call printf
pop rax

;"A⊕ B contains"
push qword 0
mov rax, 0
mov rdi, append_message_two
call printf
pop rax

;Take the sum of first and second array sizes and stores it r13 for future use
mov rax, 0
mov r13, r15
add r13, r14

;Call to display_array module which prints the new appended array of first and second array
push qword 0
mov rax, 0
mov rdi, result_array
mov rsi, r13
call display_array
pop rax

;Call to magnitude module for the result array, storing magnitude in xmm13
;Magnitude = sqrt(a^2 + b^2 + c^2 + d ^2 + ...)
push qword 0
mov rax, 0
mov rdi, result_array
mov rsi, r13
call magnitude
movsd xmm12, xmm0
pop rax

;"The magnitude of A⊕ B is %.10lf."
push qword 0
mov rax, 1
mov rdi, magnitude_message_result
movsd xmm0, xmm12
call printf
pop rax


;End of the program
pop rax ;Counter the push at the beginning
movsd xmm0, xmm12 ;Return the magnitude of the result array to the caller module

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