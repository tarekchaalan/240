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
;   File name: get_clock_freq.asm                                                                                              *
;   Language: x86 with Intel Syntax                                                                                            *
;   Max page width: 134 columns                                                                                                *
;   Compile: nasm -f elf64 -l get_clock_freq.lis -o get_clock_freq.o get_clock_freq.asm                                        *
;   Link: g++ -m64 -std=c++17 -fno-pie -no-pie -o assignment4.out main.o manager.o getradicand.o get_clock_freq.o              *
;   Purpose: This file defines a function called "getfreq" that extracts data from the processor and converts it to an         *
;            IEEE numeric quadword.                                                                                            *
;                                                                                                                              *
;*******************************************************************************************************************************

;Declaration area
global getfreq

extern atof

segment .data
   ;Empty

segment .bss
   ;Empty

segment .text
getfreq:

;Prolog: Back up the GPRs
push rbp
mov rbp, rsp
push rbx
push rcx
push rdx
push rdi
push rsi
push r8
push r9
push r10
push r11
push r12
push r13
push r14
push r15
pushf


;Extract data from processor in the form of two 4-byte strings
mov rax, 0x0000000080000004
cpuid
;Answer is in ebx:eax as big endian strings using the standard ordering of bits.
mov       r15, rbx      ;Second part of string saved in r15
mov       r14, rax      ;First part of string saved in r14


;Catenate the two short strings into one 8-byte string in big endian
and r15, 0x00000000000000FF    ;Convert non-numeric chars to nulls
shl r15, 32
or r15, r14                    ;Combined string is in r15

;Use of mask: The number 0x00000000000000FF is a mask.  
;In general masks are used to change some bits to 0 (or 1) and leave others unchanged.


;Convert string now stored in r15 to an equivalent IEEE numeric quadword.
push r15
mov rax,0          ;The value in rax is the number of xmm registers passed to atof, 
mov rdi,rsp        ;rdi now points to the start of the 8-byte string.
call atof          ;The number is now in xmm0
pop rax


;Epilogue: restore data to the values held before this function was called.
popf
pop r15
pop r14
pop r13
pop r12
pop r11
pop r10
pop r9
pop r8
pop rsi
pop rdi
pop rdx
pop rcx
pop rbx
pop rbp               ;Restore the base pointer of the stack frame of the caller.
ret

ret