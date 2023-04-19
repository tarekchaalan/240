//*******************************************************************************************************************************
//                                                                                                                              *
// Author Name: Tarek Chaalan                                                                                                   *
// Author Email: tchaalan23@csu.fullerton.edu                                                                                   *
// Course & Section: CPSC240-3                                                                                                  *
// Todays Date: March 22, 2023                                                                                                  *
//                                                                                                                              *
//*******************************************************************************************************************************

#include <stdio.h>
#include <stdint.h>
#include <time.h>
#include <sys/time.h>
#include <stdlib.h>

extern float manager(); // Declare the function defined in manager.asm

int main()
{
  printf("Welcome to Arrays of Integers\n");
  printf("Brought to you by Tarek Chaalan\n\n");

  float answer = manager(); // Call the function

  printf("\nMain has received this number %.lf and will keep it for a while.\n", answer);
  printf("Main will return 0 to the operating system. Bye.\n");
  return 0;
}