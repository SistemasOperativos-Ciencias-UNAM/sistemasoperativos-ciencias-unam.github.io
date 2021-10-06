#include <stdio.h>
#include <stdlib.h>

#define MENSAJE "Hola mundo"

int main(void)
{
  printf("%s\n", &MENSAJE);
  return EXIT_SUCCESS;
}
