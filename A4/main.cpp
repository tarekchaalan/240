//*******************************************************************************************************************************
//                                                                                                                              *
// Program name: "Benchmark".                                                                                                   *
// This program aims to test the performance of your device’s CPU when running the square root instruction in SSE and the       *
// square root program in the standard C library.                                                                               *
//                                                                                                                              *
// Copyright (C) 2023 Tarek Chaalan.                                                                                            *
//                                                                                                                              *
// This file is part of the software program "Benchmark".                                                                       *
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License    *
// version 3 as published by the Free Software Foundation.                                                                      *
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY// without even the implied           *
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.       *
// A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.                              *
//                                                                                                                              *
//*******************************************************************************************************************************


//*******************************************************************************************************************************
//                                                                                                                              *
//Author information                                                                                                            *
//  Author name: Tarek Chaalan                                                                                                  *
//  Author email: tchaalan23@csu.fullerton.edu                                                                                  *
//                                                                                                                              *
//*******************************************************************************************************************************


//*******************************************************************************************************************************
//                                                                                                                              *
//Program information                                                                                                           *
//  Program name: Benchmark                                                                                                     *
//  Programming languages: Assembly, C++, bash                                                                                  *
//  Date program began: 2023 March 5                                                                                            *
//  Date program is due: 2023 April 16                                                                                          *
//  Date of last update: 2023 April 16                                                                                          *
//  Files in this program: main.cpp, manager.c, getradicand.asm, get_clock_freq.asm                                             *
//  Status: Finished.  The program was tested extensively with no errors in WSL2.0: Ubuntu 20.04.                               *
//                                                                                                                              *
//*******************************************************************************************************************************


//*******************************************************************************************************************************
//                                                                                                                              *
//This file                                                                                                                     *
//   File name: main.cpp                                                                                                        *
//   Language: C++                                                                                                              *
//   Max page width: 134 columns                                                                                                *
//   Compile: g++ -c -m64 -Wall -std=c++14 -fno-pie -no-pie -o main.o main.cpp                                                  *
//   Link: g++ -m64 -std=c++17 -fno-pie -no-pie -o assignment4.out main.o manager.o getradicand.o get_clock_freq.o              *
//   Purpose: This file defines the main function that calls an external ASM function, "manager", and prints the result to      *
//            the console.                                                                                                      *
//                                                                                                                              *
//*******************************************************************************************************************************


#include <stdio.h>
#include <stdint.h>
#include <time.h>
#include <sys/time.h>
#include <stdlib.h>

extern "C" double manager();           // Declare the external ASM function using the "C" directive to pass parameters in the CCC standard

int main(int argc, char* argv[])
{
  // call the asm file and store the value returned from it
  double a = manager();

  //output the time of computation in nanoseconds and end message to console
  printf("\nThe main function has received this number %.5lf and will keep it for future reference.\n", a);
  printf("\nThe main function will return a zero to the operating system.\n");

  return 0;
}