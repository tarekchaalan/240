;*******************************************************************************************************************************
;                                                                                                                              *
; Author Name: Tarek Chaalan                                                                                                   *
; Author Email: tchaalan23@csu.fullerton.edu                                                                                   *
; Course & Section: CPSC240-3                                                                                                  *
; Todays Date: March 22, 2023                                                                                                  *
;                                                                                                                              *
;*******************************************************************************************************************************

global manager

extern printf
extern scanf
extern input_array
extern display_array
extern hsum
extern stdin
extern fgets
extern strlen

section .data

promptName db "Please enter your name: ",0
brief db 13, 10, "This program will compute the harmonic sum of the numbers in your array", 10, 0
prompt_a db "Enter a sequence of float numbers separated by white space", 10, 0
prompt_end db "After the last input press enter followed by Control+D: ", 10, 0
present_numbers db 13, 10,"These numbers were received and placed into the array:", 10, 0
harmonicout db "The harmonic sum of the %d numbers in this array is %.5lf", 10, 0
final_message_one db 13, 10, 13, 10,"We hope you liked this program, %s.", 10, 0
final_message_two db "This program will return the hsum to the main function", 10, 0

INPUT_LEN equ 256   ; Max bytes of name, title

section .bss  ;Reserved for uninitialized data
array_one resq 20 ;Array of 20 quad words reserved before run time.
name resb INPUT_LEN     ;reserve bytes for name
title resb INPUT_LEN    ;reserve bytes for title

section .text ;Reserved for executing instructions.

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

;Prompt user to enter name
push qword 0                ;A 16-byte boundary can be reached by pushing 8 bytes 
mov rax, 0                  ;The use of 0 xmm registers means that no data from SSE will be printed 
mov rdi, promptName         ;Outputs promptName 
call printf                 ;Call C++ function printf 
pop rax                     ;Remove push 

;Extract name from user and store it in name variable
push qword 0                ;A 16-byte boundary can be reached by pushing 8 bytes 
mov rax, 0                  ;The use of 0 xmm registers means that no data from SSE will be printed 
mov rdi, name               ;Take the "name" variable and move it into the RDI register as the first argument 
mov rsi, INPUT_LEN          ;Pass the size of the reserved bytes as the second argument to the "fgets" function 
mov rdx, [stdin]            ;Pass the address of stdin's contents as the third argument to the "fgets" function 
call fgets                  ;Invoke the C++ function "fgets" to receive input from the user, including white spaces 
pop rax                     ;Remove push 

;Remove newline char from previous fgets input of name
push qword 0                ;A 16-byte boundary can be reached by pushing 8 bytes 
mov rax, 0                  ;The use of 0 xmm registers means that no data from SSE will be printed 
mov rdi, name               ;Take the "name" variable and move it into the RDI register as the first argument 
call strlen                 ;Call the C++ function "strlen" to count the string length and store the result in register "rax" 
sub rax, 1                  ;Subtract one from the length of the string to determine the position of the '\n' character 
mov byte [name + rax], 0    ;Replace the byte at the position of the '\n' character with the null character '\0' 
pop rax                     ;Remove push 

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
mov rsi, 20         ;Array size passed in as second param
call input_array
mov r15, rax
pop rax

;"The numbers you entered are these: "
push qword 0
mov rax, 0
mov rdi, present_numbers
call printf
pop rax

;Call to display_array module which prints first array
push qword 0
mov rax, 0
mov rdi, array_one
mov rsi, r15
call display_array
pop rax

;Call to hsum module for the result array, storing hsum in xmm13
;hsum = (1/a + 1/b + 1/c + 1/d + ...)
push qword 0
mov rax, 0
mov rdi, array_one
mov rsi, r15
call hsum
movsd xmm14, xmm0
pop rax

;"The harmonic sum of the %d numbers in this array is %.5lf."
push qword 0
mov rax, 1
mov rdi, harmonicout
movsd xmm0, xmm14
call printf
pop rax

;"The hsum sum of the _ numbers in this array is: _ "
push qword 0
mov rax, 1
mov rdi, hsum
movsd xmm0, xmm12
call printf
pop rax

;"We hope you liked this program Tarek Chaalan"
push qword 0
mov rax, 0
mov rdi, final_message_one    ; load the address of final_message_one into rdi
mov rsi, name                ; load the address of name into rsi
call printf                   ; call printf to print the message with the name
pop rax

;"This program will return the sum to the main function"
push qword 0
mov rax, 0
mov rdi, final_message_two
call printf
pop rax

;End of the program
pop rax ;Counter the push at the beginning
movsd xmm0, xmm12 ;Return the hsum sum of the result array to the caller module

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