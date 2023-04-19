#!/bin/bash

#Author: Tarek Chaalan
#Program name: Midterm

rm -f *.o
rm -f *.lis
rm -f *.out

#ASM
nasm -f elf64 -l input_array.lis -o input_array.o input_array.asm
nasm -f elf64 -l manager.lis -o manager.o manager.asm
nasm -f elf64 -l hsum.lis -o hsum.o hsum.asm

#C
gcc -c -m64 -Wall -std=c++11 -o main.o main.c
gcc -c -m64 -Wall -std=c++11 -o display_array.o display_array.c

#Link object files
g++ -m64 -std=c++11 -o midterm.out main.o display_array.o hsum.o input_array.o manager.o

#Run the program:
./midterm.out

#Clean up after program is run
rm -f *.o
rm -f *.out
rm -f *.lis