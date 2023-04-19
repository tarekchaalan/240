#!/bin/bash

#Author: Tarek Chaalan
#Program name: Benchmark

rm -f *.o
rm -f *.lis
rm -f *.out

#CPP
g++ -c -m64 -Wall -std=c++14 -fno-pie -no-pie -o main.o main.cpp

#ASM
nasm -f elf64 -l manager.lis -o manager.o manager.asm
nasm -f elf64 -l getradicand.lis -o getradicand.o getradicand.asm
nasm -f elf64 -l get_clock_freq.lis -o get_clock_freq.o get_clock_freq.asm

#Link
g++ -m64 -std=c++17 -fno-pie -no-pie -o assignment4.out main.o manager.o getradicand.o get_clock_freq.o

./assignment4.out

rm -f *.o
rm -f *.lis
rm -f *.out