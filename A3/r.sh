#!/bin/bash

#Author: Tarek Chaalan
#Program name: Non-deterministic Random Numbers

rm -f *.o
rm -f *.lis
rm -f *.out

#Compile the C++ file main.cpp
g++ -c -m64 -Wall -std=c++11 -o main.o main.cpp

#Compile executive.asm
nasm -f elf64 -l executive.lis -o executive.o executive.asm

#Compile fill_random_array.asm
nasm -f elf64 -l fill_random_array.lis -o fill_random_array.o fill_random_array.asm

#Compile isnan.asm
nasm -f elf64 -l isnan.lis -o isnan.o isnan.asm

#Compile show_array.asm
nasm -f elf64 -l show_array.lis -o show_array.o show_array.asm

#Compile quick_sort.c using the gcc compiler standard 2020
gcc -c -m64 -Wall -std=c++11 -o quick_sort.o quick_sort.c

#Compile normalize.asm
nasm -f elf64 -l normalize.lis -o normalize.o normalize.asm

#Link object files using the gcc Linker standard 2020
g++ -m64 -std=c++11 -o assignment3.out main.o executive.o fill_random_array.o show_array.o quick_sort.o normalize.o isnan.o

#Run the program:
./assignment3.out

#Clean up after program is run
rm -f *.o
rm -f *.out
rm -f *.lis