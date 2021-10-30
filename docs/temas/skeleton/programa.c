#include <stdio.h>
#include <stdlib.h>
#include <strings.h>

int main(int argc, char* argv[], char* envp[])
{
  /* Inicializando buffer */
  size_t tamanio=64;
  char mensaje[tamanio];
  bzero(mensaje, tamanio);
  
  /* Leyendo y escribiendo en los archivos abiertos */
  printf("Escribe un mensaje:\n");
  scanf("%s", (char *) &mensaje);
  fprintf(stderr, "El mensaje fue:\t%s\n", mensaje);

  /* Leyendo los argumentos de entrada */
  for (int i=0 ; i<argc ; i++)
  {
    printf("Argumento # %d es:\t'%s'\n", i, argv[i]);
  }

  /* Leyendo las variables de entorno */
  for (int j=0 ; envp[j]!=NULL ; j++)
  {
    fprintf(stderr, "Variable de entorno # %d es:\t'%s'\n", j, envp[j]);
  }

  /* Código de salida */
  return EXIT_SUCCESS;
}
