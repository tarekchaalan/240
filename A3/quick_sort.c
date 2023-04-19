//*******************************************************************************************************************************
//                                                                                                                              *
// Program name: "Non-deterministic Random Numbers".                                                                            *
// The program is designed to produce a specific number of random numbers based on user input and then store these values in    *
// an array. The generated random numbers will be printed in both IEEE754 and scientific decimal format. Additionally, the      *
// array will be sorted in ascending order and normalized to fall within the range of 1.0 to 2.0. The array will be printed in  *
// its original, sorted, and normalized states, all in both IEEE754 and scientific decimal formats.                             *
//                                                                                                                              *
// Copyright (C) 2023 Tarek Chaalan.                                                                                            *
//                                                                                                                              *
// This file is part of the software program "Non-deterministic Random Numbers".                                                *
// This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License    *
// version 3 as published by the Free Software Foundation.                                                                      *
// This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY// without even the implied          *
// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.       *
// A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.                             *
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
//  Program name: Non-deterministic Random Numbers                                                                              *
//  Programming languages: Assembly, C, C++, bash                                                                               *
//  Date program began: 2023 March 5                                                                                            *
//  Date program is due: 2023 March 13                                                                                          *
//  Date of last update: 2023 March 13                                                                                          *
//  Files in this program: main.cpp, quick_sort.c, executive.asm, fill_random_array.asm,                                        *
//                         isnan.asm, show_array.asm normalioze.asm                                                             *
//  Status: Finished.  The program was tested extensively with no errors in WSL2.0: Ubuntu 20.04.                               *
//                                                                                                                              *
//*******************************************************************************************************************************


//*******************************************************************************************************************************
//                                                                                                                              *
//This file                                                                                                                     *
//   File name: quick_sort.c                                                                                                    *
//   Language: C                                                                                                                *
//   Max page width: 134 columns                                                                                                *
//   Compile: g++ -c -m64 -Wall -std=c++14 -fno-pie -no-pie -o main.o main.cpp                                                  *
//   Link: g++ -m64 -std=c++17 -fno-pie -no-pie -o assignment3.out main.o executive.o fill_random_array.o show_array.o          *
//         quick_sort.o normalize.o isnan.o                                                                                     *
//   Purpose: This program acts as a reference to a function that compares two elements and returns a negative integer if the   *
//            first argument is smaller than the second argument. Alternatively, the function returns a positive integer if the *
//            first argument is greater than the second argument.                                                               *
//                                                                                                                              *
//*******************************************************************************************************************************

#include <stdio.h>
#include <stdint.h>
#include <time.h>
#include <sys/time.h>
#include <stdlib.h>

extern int quick_sort(const void *a, const void *b);

//quick_sort is a pointer to a function that compares two elements
int quick_sort(const void *a, const void *b)
{
    if (*(double*)a > *(double*)b)      //if first argument is greater than the second, return a positive integer
        return 1;

    if (*(double*)a < *(double*)b)      //if second argument is less than the second, return a negative integer
        return -1;

    return 0;
}