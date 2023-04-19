//*******************************************************************************************************************************
//                                                                                                                              *
// Program name: "Pythagoras".                                                                                                  *
// This program will allow a user to input two sides of a triangle, then it will find the length of the hypotenuse              *
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
//  Program name: Pythagoras                                                                                                    *
//  Programming languages: Assembly, C, bash                                                                                    *
//  Date program began: 2023 January 22                                                                                         *
//  Date of last update: 2023 February 6                                                                                        *
//  Date of reorganization of comments: 2023 February 6                                                                         *
//  Files in this program: main.c, manager.asm, display_array.c, magnitude.asm, append.asm, input_array.asm                     *
//  Status: Finished.  The program was tested extensively with no errors in WSL2.0: Ubuntu 20.04.                               *
//                                                                                                                              *
//*******************************************************************************************************************************


//*******************************************************************************************************************************
//                                                                                                                              *
//This file                                                                                                                     *
//   File name: triangle.c                                                                                                      *
//   Language: C                                                                                                                *
//   Max page width: 134 columns                                                                                                *
//   Compile: gcc -c -Wall -m64 -no-pie -o main.o main.c -std=c11                                                               *
//   Link: gcc -m64 -no-pie -o addFloatArray.out manager.o input_array.o append.o main.o magnitude.o display_array.o -std=c11   *
//   Purpose: execute the "triangle" function and print a message with the resulting number.                                    *
//                                                                                                                              *
//*******************************************************************************************************************************

#include <stdio.h>

extern double triangle(); //Assembly module that will direct calls to other functions

int main(int argc, char **argv)
{
       printf("CPSC 240 Assignment 1 programmed by Tarek Chaalan.\n"
              "Please contact me at tchaalan23@csu.fullerton.edu if there are any questions.\n\n");

       const double res = triangle();

       printf("\n\nThe main file received this number: %lf, and will keep it for now.\nWe hoped you enjoyed your right angles. Have a good day. A zero will be sent to your operating system. \n", res);
       return 0;
}