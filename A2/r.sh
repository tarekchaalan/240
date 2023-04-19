#!/bin/bash

#Program: Append Float Array
#Author: Tarek Chaalan

#Purpose: script file to run the program files together.

#Clear any previously compiled outputs
rm -f *.o
rm -f *.out
rm -f *.lis


#Assemble manager.asm
nasm -f elf64 -l manager.lis -o manager.o manager.asm

#Assemble input_array.asm
nasm -f elf64 -l input_array.lis -o input_array.o input_array.asm

#Assemble magnitude.asm
nasm -f elf64 -l magnitude.lis -o magnitude.o magnitude.asm

#Assemble append.asm
nasm -f elf64 -l append.lis -o append.o append.asm

#Compile display_array.c using the gcc compiler standard 2011
gcc -c -Wall -no-pie -m64 -std=c11 -o display_array.o display_array.c

#Compile main.c using the gcc compiler standard 2011
gcc -c -Wall -m64 -no-pie -o main.o main.c -std=c11

#Link object files using the gcc Linker standard 2011
gcc -m64 -no-pie -o assignment2.out manager.o input_array.o append.o main.o magnitude.o display_array.o -std=c11

#Run the Append Array Program
./assignment2.out

#Clean up after program is run
rm -f *.o
rm -f *.out
rm -f *.lis

#Script file terminated