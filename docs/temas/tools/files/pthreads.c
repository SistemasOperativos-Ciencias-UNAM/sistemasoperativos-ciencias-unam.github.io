#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#define MENSAJE "Hola mundo"

void *hello(void *tid)
{
  printf("%s\n", &MENSAJE);
  pthread_exit(NULL);
}

int main(void)
{
  pthread_t t;
  long tid=0;
  pthread_create(&t, NULL, hello, (void *) tid);
  pthread_join(t, NULL);
  return EXIT_SUCCESS;
}
