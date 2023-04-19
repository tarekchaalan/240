//*******************************************************************************************************************************
//                                                                                                                              *
// Author Name: Tarek Chaalan                                                                                                   *
// Author Email: tchaalan23@csu.fullerton.edu                                                                                   *
// Course & Section: CPSC240-3                                                                                                  *
// Todays Date: March 22, 2023                                                                                                  *
//                                                                                                                              *
//*******************************************************************************************************************************

#include <stdio.h>

extern void display_array(double arr[], int arr_size);

void display_array(double arr[], int arr_size)
{
  for (int i = 0; i < arr_size; i++)
  {
    printf("%g\n", arr[i]);
  }
  printf("\n");
}
