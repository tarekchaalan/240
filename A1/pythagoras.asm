;*******************************************************************************************************************************
;                                                                                                                              *
; Program name: "Pythagoras".                                                                                                  *
; This program will allow a user to input two sides of a triangle, then it will find the length of the hypotenuse              *
; Copyright (C) 2023 Tarek Chaalan.                                                                                            *
;                                                                                                                              *
;This file is part of the software program "Append Float Array".                                                               *
;This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License     *
;version 3 as published by the Free Software Foundation.                                                                       *
;This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied            *
;warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.        *
;A copy of the GNU General Public License v3 is available here:  <https:;www.gnu.org/licenses/>.                               *
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
;  Program name: Pythagoras                                                                                                    *
;  Programming languages: Assembly, C, bash                                                                                    *
;  Date program began: 2023 January 22                                                                                         *
;  Date of last update: 2023 February 6                                                                                        *
;  Date of reorganization of comments: 2023 February 6                                                                         *
;  Files in this program: main.c, manager.asm, display_array.c, magnitude.asm, append.asm, input_array.asm                     *
;  Status: Finished.  The program was tested extensively with no errors in WSL2.0: Ubuntu 20.04.                               *
;                                                                                                                              *
;*******************************************************************************************************************************


;*******************************************************************************************************************************
;                                                                                                                              *
;This file                                                                                                                     *
;   File name: Pythagoras.asm                                                                                                  *
;   Language: x86 with Intel Syntax                                                                                            *
;   Max page width: 134 columns                                                                                                *
;   Compile: gcc -c -Wall -m64 -no-pie -o main.o main.c -std=c11                                                               *
;   Link: gcc -m64 -no-pie -o addFloatArray.out manager.o input_array.o append.o main.o magnitude.o display_array.o -std=c11   *
;   Purpose: Reads the length of two sides of a triangle, calculates and returns the length of the hypotenuse, and prints      *
;            out the two sides and the hypotenuse of the triangle.                                                             *
;                                                                                                                              *
;*******************************************************************************************************************************

extern printf
extern scanf
extern fgets
extern stdin
extern strchr
global triangle

segment .data

LF  equ 10
NUL equ 0

num_buflen equ 256

num_neg1 dq -1.0
num_zero dq 0.0

msg_lf db LF, NUL
msg_str_f db "%s", NUL
msg_strln_f db "%s", LF, NUL
msg_enter_firstside   db "Enter the length of the first side of the triangle: ", NUL
msg_enter_secondside  db "Enter the length of the second side of the triangle: ", NUL

msg_input_side_f db "%lf", NUL

msg_sides db 0Ah, "Thank You. You entered two sides: %.8lf and %.8lf.", 0Ah, NUL

msg_enter_hypot_f db "The length of the hypotenuse is %lf.", NUL

msg_invalid db "Invalid input. Exiting assembly.", LF, NUL

segment .bss

buf_side1     resq 1
buf_side2     resq 1
buf_hypot     resq 1

segment .text

triangle:
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

; Print the first side message.
        mov  rax, 0
        mov  rdi, msg_str_f            ; arg1
        mov  rsi, msg_enter_firstside  ; arg2
        call printf                    ; printf()

; Read the first side length using scanf(). We'll use its rax return to determine
; if the read is successful.
        mov  rax, 0
        mov  rdi, msg_input_side_f     ; arg1
        mov  rsi, buf_side1            ; arg2: double ptr
        call scanf                     ; scanf()
        cmp  rax, 0                    ; if (scanf() == NULL)
        je   invalid                   ; then goto invalid

; Validate side 1 >= 0.
        movsd  xmm1, [buf_side1]
        comisd xmm1, [num_zero]        ; buf_side1 vs. num_zero
        jbe    invalid                 ; if (buf_side1 <= num_zero)

; Print the second side message.
        mov  rax, 0
        mov  rdi, msg_str_f            ; arg1
        mov  rsi, msg_enter_secondside ; arg2
        call printf                    ; printf()

; Read the second side length using scanf(). We'll use its rax return to determine
; if the read is successful.
        mov  rax, 0
        mov  rdi, msg_input_side_f     ; arg1
        mov  rsi, buf_side2            ; arg2: double ptr
        call scanf                     ; scanf()
        cmp  rax, 0                    ; if (scanf() == NULL)
        je   invalid                   ; then goto invalid

; Validate side 2 >= 0.
        movsd  xmm1, [buf_side2]
        comisd xmm1, [num_zero]        ; buf_side2 vs. num_zero
        jbe    invalid                 ; if (buf_side2 <= num_zero)

;
; Print the two sides.
        mov  rdi, msg_sides
        movsd xmm0, [buf_side1]
        movsd xmm1, [buf_side2]
        call  printf

; Formula for the hypotenuse: sqrt(pow(a, 2) + pow(b, 2))
; Translated into C then Assembly:
        movsd  xmm11, [buf_side1]      ; xmm11      = *buf_side1
        movsd  xmm12, [buf_side2]      ; xmm12      = *buf_side2
        mulsd  xmm11, xmm11            ; xmm11      *= xmm11
        mulsd  xmm12, xmm12            ; xmm12      *= xmm12
        addsd  xmm11, xmm12            ; xmm11      += xmm12
        sqrtsd xmm13, xmm11            ; xmm13      = sqrtsd(xmm11)
        movsd  [buf_hypot], xmm13      ; *buf_hypot = xmm13

        mov   rax, 1
        mov   rdi, msg_enter_hypot_f
        movsd xmm0, [buf_hypot]
        call  printf

; Ensure we return the hypotenuse.
        movsd xmm0, [buf_hypot]

return:
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

invalid:
        mov  rax, 0
        mov  rdi, msg_invalid          ; arg1
        call printf                    ; printf()

        movsd xmm0, [num_neg1]         ; Write garbage float.
        jmp   return                   ; return