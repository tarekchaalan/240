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
;   File name: executive.asm                                                                                                   *
;   Language: x86 with Intel Syntax                                                                                            *
;   Max page width: 134 columns                                                                                                *
;   Compile: nasm -f elf64 -l executive.lis -o executive.o executive.asm                                                       *
;   Link: g++ -m64 -std=c++17 -fno-pie -no-pie -o assignment3.out main.o executive.o fill_random_array.o show_array.o          *
;         quick_sort.o normalize.o isnan.o                                                                                     *
;   Purpose: This file is the main assembly caller file. This file mainly calls other functions necessary to run the program   *                                                                                                   *
;                                                                                                                              *
;*******************************************************************************************************************************

; Declare external C++ functions & make funct 'executive' visible to other languages & create constant
extern printf               ;print to console
extern scanf                ;read input from console
extern fgets                ;read input from console that contain white space
extern stdin                ;performs fgets
extern strlen               ;counts the size of string
extern atoi                 ;converts string to integer
extern fill_random_array    ;fills the array with random numbers
extern show_array           ;prints numbers in array in both IEEE754 and scientific decimal format
extern qsort                ;C++ function qsort
extern quick_sort           ;asm module which becomes a pointer to a function that compares two elements
extern normalize            ;asm module to normalize the numbers in the array

global executive     

segment .data                       
;========== message to be printed to user =================================================================================================================================
promptName db "Please enter your name: ",0                                              ;prompt user to enter name
promptTitle db "Please enter your title (Mr,Ms,Sargent,Chief,Project Leader,etc): ",0   ;prompt user to enter title
greetUser db "Nice to meet you ",0                                                      ;greet user using name and title entered combined
programDesc db 10,10,"This program will generate 64-bit IEEE float numbers.",10,0       ;brief description of the program
promptNumbers db "How many numbers do you want. Today's limit is 100 per customer. ",0  ;prompt user for the amount of number to be generated
confirm db "Your numbers have been stored in an array. Here is that array.",10,10,0     ;confirm user that random numbers have been stored in array and will print it
sortArray db 10,"The array is now being sorted.",10,0                                   ;tell user that the array is being sorted from smallest to largest
outputSortedArray db 10,"Here is the updated array.",10,10,0                            ;tell user that the sorted array will be printed in the next line
goodbye1 db 10,"Good bye ",0                                                            ;print goodbye message to user
goodbye2 db ". You are welcome any time.",10,0                                          ;continuation of prior goodbye message
rejectInput db "The value you input is invalid. Please try again.",10,0                 ;tell user that the amount of number to be generated is out of bounds
outputNormalized db 10,"The random numbers will be normalized. Here is the normalized array",10,10,0    ;tell user that the numbers are being normalized and will print
                                                                                                        ;in the following line
format db "%s", 0   ;Format indicating a null-terminated string, c-string
spc db " ", 0       ;space character

INPUT_LEN equ 256   ; Max bytes of name, title

segment .bss
array resq 100          ;array to store random numbers (max capacity=100)
input_size resq 20      ;to store input by user of the amount of numbers to be generated
name resb INPUT_LEN     ;reserve bytes for name
title resb INPUT_LEN    ;reserve bytes for title

segment .text

executive:              ;start execution of program

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

push qword 0                ;push to remain on the boundary

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

;Prompt user for title 
push qword 0                ;A 16-byte boundary can be reached by pushing 8 bytes 
mov rax, 0                  ;The use of 0 xmm registers means that no data from SSE will be printed 
mov rdi, promptTitle        ;Outputs promptTitle 
call printf                 ;Call C++ function printf 
pop rax                     ;Remove push 

;Extract title from user and store it in title variable 
push qword 0                ;A 16-byte boundary can be reached by pushing 8 bytes 
mov rax, 0                  ;The use of 0 xmm registers means that no data from SSE will be printed 
mov rdi, title              ;Transfer the variable 'title' that represents the title of something to the register 'rdi', positioning it as the first argument 
mov rsi, INPUT_LEN          ;Pass the size of the reserved bytes as the second argument to the "fgets" function 
mov rdx, [stdin]            ;Pass the address of stdin's contents as the third argument to the "fgets" function 
call fgets                  ;Invoke the C++ function "fgets" to receive input from the user, including white spaces 
pop rax                     ;Remove push 

;Remove newline char from previous fgets input of title
push qword 0                ;A 16-byte boundary can be reached by pushing 8 bytes 
mov rax, 0                  ;The use of 0 xmm registers means that no data from SSE will be printed 
mov rdi, title              ;Transfer the variable 'title' that represents the title of something to the register 'rdi', positioning it as the first argument 
call strlen                 ;Call the C++ function "strlen" to count the string length and store the result in register "rax" 
sub rax, 1                  ;Subtract one from the length of the string to determine the position of the '\n' character 
mov byte [title + rax], 0   ;Replace the byte at the position of the '\n' character with the null character '\0' 
pop rax                     ;Remove push 

;Output welcome message that contains title and name of user that was previously obtained
push qword 0                ;A 16-byte boundary can be reached by pushing 8 bytes 
mov rax, 0                  ;The use of 0 xmm registers means that no data from SSE will be printed 
mov rdi, greetUser          ;Outputs greetUser 
call printf                 ;Call C++ function printf 
pop rax                     ;Remove push 

;Output title of user 
push qword 0                ;A 16-byte boundary can be reached by pushing 8 bytes 
mov rax, 0                  ;The use of 0 xmm registers means that no data from SSE will be printed 
mov rdi, title              ;title entered by user 
call printf                 ;Call C++ function printf 
pop rax                     ;Remove push 

;Output space required in between title and name of user
push qword 0                ;A 16-byte boundary can be reached by pushing 8 bytes 
mov rax, 0                  ;The use of 0 xmm registers means that no data from SSE will be printed 
mov rdi, spc                ;Inserts a blank space character " " in order to display a space between the title and the name of the user that will be printed 
call printf                 ;Call C++ function printf 
pop rax                     ;Remove push 

;Output name of user 
push qword 0                ;A 16-byte boundary can be reached by pushing 8 bytes 
mov rax, 0                  ;The use of 0 xmm registers means that no data from SSE will be printed 
mov rdi, name               ;name entered by user
call printf                 ;Call C++ function printf 
pop rax                     ;Remove push 

;Output brief description of program 
push qword 0                ;A 16-byte boundary can be reached by pushing 8 bytes 
mov rax, 0                  ;The use of 0 xmm registers means that no data from SSE will be printed 
mov rdi, programDesc        ;Outputs programDesc 
call printf                 ;Call C++ function printf 
pop rax                     ;Remove push 

;Prompt user for the amount of float to store in array 
beginLoop:                  ;if value entered is out of bound, prompt the user again to input a new value
push qword 0                ;A 16-byte boundary can be reached by pushing 8 bytes 
mov rax, 0                  ;The use of 0 xmm registers means that no data from SSE will be printed 
mov rdi, promptNumbers      ;"How many numbers do you want. Today's limit is 100 per customer. "
call printf                 ;Call C++ function printf 
pop rax                     ;Remove push 

;Extract input from user for the amount desired
push qword 0                ;A 16-byte boundary can be reached by pushing 8 bytes 
mov rax, 0                  ;The use of 0 xmm registers means that no data from SSE will be printed 
mov rdi, format             ;"%s"
mov rsi, input_size         ;point scanf to input_size variable
call scanf                  ;call external C++ scanf function
pop rax                     ;Remove push 

;Convert the string for amount of random number to be generated entered by user to integer
push qword 0                ;A 16-byte boundary can be reached by pushing 8 bytes 
mov rdi, input_size         ;move input_size variable that contains the amount in string format to rdi to pass as first argument for atoi function
call atoi                   ;call external C++ function that convert string and return it in integer format
mov r14, rax                ;store the value returned by atoi in rax to r14 (r14 now stores the amount of random numbers to be generated)
pop rax                     ;Remove push 

;Check if value entered by user is out of bounds, if out of bounds prompt user to try again 
cmp r14, 100                ;compare value with 100 (max size of array)
jg outofrange               ;if greater than 100, jump to outofrange to print error message
cmp r14, 0                  ;compare value with 0 (to check for negative value)
js outofrange               ;if smaller than 0 (negative value entered), jump to outofrange to print error message
jmp outofLoop               ;if value is within bounds (0<=x<=100), jump to outofLoop to continue program

;if value entered is out of bounds, print error message and jump to beginLoop to prompt user to enter a new value 
outofrange:                 
push qword 0                ;A 16-byte boundary can be reached by pushing 8 bytes 
mov rax, 0                  ;The use of 0 xmm registers means that no data from SSE will be printed 
mov rdi, rejectInput        ;"The value you input is invalid. Please try again."
call printf                 ;Call C++ function printf 
pop rax                     ;Remove push 
jmp beginLoop               ;jump to beginLoop to prompt user for new input

outofLoop:                  ;if input value is valid, continue here

;Fill array with user specified amount by calling fill_random_array module 
push qword 0                ;A 16-byte boundary can be reached by pushing 8 bytes 
mov rax, 0                  ;The use of 0 xmm registers means that no data from SSE will be printed 
mov rdi, array              ;move the array to rdi so that it will be the first parameter passed to fill_random_array module
mov rsi, r14                ;move the size of array to rsi so that it will be the second parameter passed to fill_random_array module
call fill_random_array      ;call asm module fill_random_array that fill the array with random numbers
pop rax                     ;Remove push 

;Output to let user know that the numbers have been stored in the array 
push qword 0                ;A 16-byte boundary can be reached by pushing 8 bytes 
mov rax, 0                  ;The use of 0 xmm registers means that no data from SSE will be printed 
mov rdi, confirm            ;"Your numbers have been stored in an array. Here is that array."
call printf                 ;Call C++ function printf 
pop rax                     ;Remove push 

;Call show_array module to output the contents of the array 
push qword 0                ;A 16-byte boundary can be reached by pushing 8 bytes 
mov rax, 0                  ;The use of 0 xmm registers means that no data from SSE will be printed 
mov rdi, array              ;move array to rdi so that it will be the first parameter passed to show_array
mov rsi, r14                ;move array size to rsi so that it will be the second parameter passed to show_array
call show_array             ;call show_array module that outputs the numbers in array in both IEEE754 and scientific decimal format
pop rax                     ;Remove push 

;Output to tell user that the array is being sorted 
push qword 0                ;A 16-byte boundary can be reached by pushing 8 bytes 
mov rax, 0                  ;The use of 0 xmm registers means that no data from SSE will be printed 
mov rdi, sortArray          ;"The array is now being sorted."
call printf                 ;Call C++ function printf 
pop rax                     ;Remove push 

;Sort contents of the array 
mov rdi, array              ;move array to rdi so that it will be the first parameter passed when calling qsort
mov rsi, r14                ;move size of array to rsi so that it will be the second parameter passed when calling qsort
mov rdx, 8                  ;move the size of each number (8 bytes) to rdx so that it will be the third parameter passed when calling qsort
mov rcx, quick_sort         ;move the function quick_sort to rcx, so that it will be the fourth parameter being passed to qsort
call qsort                  ;call external C++ qsort function that sorts the numbers in the array from smallest to largest

;Output heading to tell user that the array below is the updated version
push qword 0                ;A 16-byte boundary can be reached by pushing 8 bytes 
mov rax, 0                  ;The use of 0 xmm registers means that no data from SSE will be printed 
mov rdi, outputSortedArray  ;"Here is the updated array."
call printf                 ;Call C++ function printf 
pop rax                     ;Remove push 

;Output the sorted array by calling show_array module
push qword 0                ;A 16-byte boundary can be reached by pushing 8 bytes 
mov rax, 0                  ;The use of 0 xmm registers means that no data from SSE will be printed 
mov rdi, array              ;move array to rdi so that it will be the first parameter passed to show_array
mov rsi, r14                ;move size of array to rsi so that it will be the second parameter passed to show_array
call show_array             ;call show_array module that prints the number in the array in both IEEE754 and scientific decimal format
pop rax                     ;Remove push 

;Output to tell user that the array will be normalized 
push qword 0                ;A 16-byte boundary can be reached by pushing 8 bytes 
mov rax, 0                  ;The use of 0 xmm registers means that no data from SSE will be printed 
mov rdi, outputNormalized   ;"The random numbers will be normalized. Here is the normalized array"
call printf                 ;Call C++ function printf 
pop rax                     ;Remove push 

;Call normalize module to normalize the array
push qword 0                ;A 16-byte boundary can be reached by pushing 8 bytes 
mov rax, 0                  ;The use of 0 xmm registers means that no data from SSE will be printed 
mov rdi, array              ;move array to rdi so that it will be the first parameter passed to normalize
mov rsi, r14                ;move size of array to rsi so that it will be the second parameter passed to normalize
call normalize              ;call normalize module to normalize the numbers in the array
pop rax                     ;Remove push 

;Output the normalized array by calling show_array module 
push qword 0                ;A 16-byte boundary can be reached by pushing 8 bytes 
mov rax, 0                  ;The use of 0 xmm registers means that no data from SSE will be printed 
mov rdi, array              ;move array to rdi so that it will be the first parameter passed to show_array
mov rsi, r14                ;move size of array to rsi so that it will be the second parameter passed to show_array
call show_array             ;call show_array module that prints the number in the array in both IEEE754 and scientific decimal format
pop rax                     ;Remove push 

;Output goodbye message
push qword 0                ;A 16-byte boundary can be reached by pushing 8 bytes 
mov rax, 0                  ;The use of 0 xmm registers means that no data from SSE will be printed 
mov rdi, goodbye1           ;"Good bye "
call printf                 ;Call C++ function printf 
pop rax                     ;Remove push 

;Output title in between the goodbye message 
push qword 0                ;A 16-byte boundary can be reached by pushing 8 bytes 
mov rax, 0                  ;The use of 0 xmm registers means that no data from SSE will be printed 
mov rdi, title              ;title variable that stores the title entered by user
call printf                 ;call c++ print function
pop rax                     ;Remove push 

;Output the rest of the goodbye message 
push qword 0                ;A 16-byte boundary can be reached by pushing 8 bytes 
mov rax, 0                  ;The use of 0 xmm registers means that no data from SSE will be printed 
mov rdi, goodbye2           ;". You are welcome any time."
call printf                 ;Call C++ function printf 
pop rax                     ;Remove push 

pop rax                     ;counter push at the start of program
mov rax, name               ;return the name variable to main.cpp

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