//*******************************************************************************************************************************
//                                                                                                                              *
//Program name: "Append Float Array".                                                                                           *
// This program will allow a user to input two float arrays, then it will append them into a third array                        *
// Copyright (C) 2023 Tarek Chaalan.                                                                                            *
//                                                                                                                              *
//This file is part of the software program "Append Float Array".                                                               *
//This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License     *
//version 3 as published by the Free Software Foundation.                                                                       *
//This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY// without even the implied           *
//warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.        *
//A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.                              *
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
//   File name: main.c                                                                                                          *
//   Language: C                                                                                                                *
//   Max page width: 134 columns                                                                                                *
//   Compile: gcc -c -Wall -m64 -no-pie -o main.o main.c -std=c11                                                               *
//   Link: gcc -m64 -no-pie -o addFloatArray.out manager.o input_array.o append.o main.o magnitude.o display_array.o -std=c11   *
//   Purpose: This program is the driver module that will call manager() to initialize the array operations                     *
//                                                                                                                              *
//*******************************************************************************************************************************

#include <stdio.h>
#include <stdint.h>
#include <time.h>
#include <sys/time.h>
#include <stdlib.h>

extern double manager();  //Assembly module that will direct calls to other functions and will fill an array and computer its magnitude

int main(int argc, char *argv[])
{
  printf("Welcome to Arrays of floats\n");
  printf("Brought to you by Tarek Chaalan\n\n");

  double answer = manager();  //The control module will return the magnitude of the array contents

  printf("\nMain received %.10lf and will keep it for future use.\n", answer);
  printf("Main will return 0 to the operating system. Bye\n");
}