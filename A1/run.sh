#!/bin/bash

#Program: Pythagoras
#Author: Tarek Chaalan

#Purpose: script file to run the program files together.

#Clear any previously compiled outputs
rm -f *.o
rm -f *.out
rm -f *.lis

# Assemble the pythagoras.asm file
nasm -f elf64 -l pythagoras.lis -o pythagoras.o pythagoras.asm

# Compile the triangle.c file
gcc -c -Wall -no-pie -m64 -std=c11 -o triangle.o triangle.c

# Link the object files to create the executable
gcc -m64 -no-pie -o assignment1.out pythagoras.o triangle.o

# Run the executable
./assignment1.out

#Clean up after program is run
rm -f *.o
rm -f *.out
rm -f *.lis
