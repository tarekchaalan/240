;*******************************************************************************************************************************
;                                                                                                                              *
; Program name: "Benchmark".                                                                                                   *
; This program aims to test the performance of your device’s CPU when running the square root instruction in SSE and the       *
; square root program in the standard C library.                                                                               *
;                                                                                                                              *
; Copyright (C) 2023 Tarek Chaalan.                                                                                            *
;                                                                                                                              *
; This file is part of the software program "Benchmark".                                                                       *
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
;  Program name: Benchmark                                                                                                     *
;  Programming languages: Assembly, C++, bash                                                                                  *
;  Date program began: 2023 March 5                                                                                            *
;  Date program is due: 2023 April 16                                                                                          *
;  Date of last update: 2023 April 16                                                                                          *
;  Files in this program: main.cpp, manager.c, getradicand.asm, get_clock_freq.asm                                             *
;  Status: Finished.  The program was tested extensively with no errors in WSL2.0: Ubuntu 20.04.                               *
;                                                                                                                              *
;*******************************************************************************************************************************


;*******************************************************************************************************************************
;                                                                                                                              *
;This file                                                                                                                     *
;   File name: getradicand.asm                                                                                                 *
;   Language: x86 with Intel Syntax                                                                                            *
;   Max page width: 134 columns                                                                                                *
;   Compile: nasm -f elf64 -l getradicand.lis -o getradicand.o getradicand.asm                                                 *
;   Link: g++ -m64 -std=c++17 -fno-pie -no-pie -o assignment4.out main.o manager.o getradicand.o get_clock_freq.o              *
;   Purpose: The purpose of this file is to prompt the user to input a floating point number for square root benchmarking, and *
;            then extract that input using the scanf function                                                                  *
;                                                                                                                              *
;*******************************************************************************************************************************

;===== Begin code area ====================================================================================================================================================
extern printf           ;external C++ function to print to console
extern scanf            ;external C++ function to read input from console

global getradicand      

segment .data       ;Place initialized data here
;========== message to be printed to user =================================================================================================================================
promptRadicand db 10,"Please enter a floating radicand for square root bench marking: ",0      ;prompt user for float to be used for square root benchmarking

one_float_format db "%lf",0

segment .bss

segment .text

getradicand:                 ;start execution of program

;Prolog ===== Insurance for any caller of this assembly module ============================================================================================================
;Any future program calling this module that the data in the caller's GPRs will not be modified.
push rbp                                                    ;Push memory address of base of previous stack frame onto stack top
mov  rbp,rsp                                                ;Copy value of stack pointer into base pointer, rbp = rsp = both point to stack top
; Rbp now holds the address of the new stack frame, i.e "top" of stack
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

push qword 0                    ;push to remain on the boundary

;========== Output prompt to ask user to input float ===================================================================================================================
push qword 0                    ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 0                      ;no data from SSE will be printed i.e. 0 xmm registers used
mov rdi, promptRadicand         ;"Please enter a floating radicand for square root bench marking: "
call printf                     ;call external C++ print function
pop rax                         ;remove earlier push

;========== Extract user input using scanf =============================================================================================================================
push qword 0                    ;Push 8 bytes to get onto an 16-byte boundary
mov rax, 1                      ;1 xmm register will be printed in this section
mov rdi, one_float_format       ;"%lf"
mov rsi, rsp                    ;point scanf to the reserved storage
call scanf                      ;call external C++ function to extract user input
movsd xmm0, [rsp]               ;move the float entered by user to xmm0
pop rax                         ;remove earlier push

pop rax                         ;counter push at the beginning of program
;===== Restore original values to integer registers ====================================================================================================================
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