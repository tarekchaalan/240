//*******************************************************************************************************************************
//                                                                                                                              *
// Program name: "Append Float Array".                                                                                          *
// This program will allow a user to input two float arrays, then it will append them into a third array                        *
// Copyright (C) 2023 Tarek Chaalan.                                                                                            *
//                                                                                                                              *
// This file is part of the software program "Append Float Array".                                                              *
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
//  Program name: Append Float Array                                                                                            *
//  Programming languages: Assembly, C, bash                                                                                    *
//  Date program began: 2023 February 6                                                                                         *
//  Date of last update: 2023 February 21                                                                                       *
//  Date of reorganization of comments: 2023 February 21                                                                        *
//  Files in this program: main.c, manager.asm, display_array.c, magnitude.asm, append.asm, input_array.asm                     *
//  Status: Finished.  The program was tested extensively with no errors in WSL2.0: Ubuntu 20.04.                               *
//                                                                                                                              *
//*******************************************************************************************************************************


//*******************************************************************************************************************************
//                                                                                                                              *
//This file                                                                                                                     *
//   File name: display_array.c                                                                                                 *
//   Language: C                                                                                                                *
//   Max page width: 134 columns                                                                                                *
//   Compile: gcc -c -Wall -no-pie -m64 -std=c11 -o display_array.o display_array.c                                             *
//   Link: gcc -m64 -no-pie -o addFloatArray.out manager.o input_array.o append.o main.o magnitude.o display_array.o -std=c11   *
//   Purpose: The control module will invoke the function named "display_array", providing it with the user-defined array and   *
//            the size of that array. Next, the Display function will output the contents of the array to the terminal.         *
//                                                                                                                              *
//*******************************************************************************************************************************

#include <stdio.h>

extern void display_array(double arr[], int arr_size);

//Prints the contents of the array, up to arr_size, determined by the input_array asm module
void display_array(double arr[], int arr_size) {
  for (int i = 0; i < arr_size; i++)
  {
    printf("%.5lf   ", arr[i]);
  }
  printf("\n");
}