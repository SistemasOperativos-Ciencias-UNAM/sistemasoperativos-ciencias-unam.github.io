---
# https://www.mkdocs.org/user-guide/writing-your-docs/#meta-data
title: Práctica pthreads
authors:
- Andrés Leonardo Hernández Bermúdez
---
# Práctica `pthreads`

## Programa 1

Crear un programa que implemente la biblioteca `pthread.h`, que incluya comentarios explicando cada bloque de funciones y que cumpla con los siguientes requerimientos:

1. Crear un programa con 2 hilos:

  + Hilo principal (implicito en `main`)
  + Hilo explícito (`pthread_create`)

2. Establecer en la *función de trabajo* del hilo explícito

  + Imprimir fecha actual
  + El nombre de la máquina (hostname)
  + El nombre de los integrantes del equipo
  + Llamar `pthread_exit(NULL)` al terminar la *función de trabajo*

3. Hacer un archivo `Makefile` que ayude a compilar y (opcionalmente) ejecutar el programa

  + Explicar con comentarios que hace cada línea o bloque
  + Es válido utilizar directivas `@echo` por si quieren imprimir mensajes en algún punto

```Makefile
# comentario

hello:	hello.c
	cc -pthread -o hello hello.c
	@echo Corriendo
	./hello
```

## Ejemplos de código y ayuda adicional

+ Repositorio con ejemplos de código que utiliza `pthreads` [1]

    * [1] <https://gitlab.com/SistemasOperativos-Ciencias-UNAM/pthreads>

+ Ubicar el archivo `hello.c` en el directorio `src` [2]

    * [2] <https://gitlab.com/SistemasOperativos-Ciencias-UNAM/pthreads/blob/master/src/hello.c>

+ Intentar compilarlo utilizando alguna de estas formas:

    * `cc -lpthread -o hello hello.c`
    * `gcc -pthread -o hello hello.c`

+ Utilizar la forma correcta de compilación en el `Makefile`

    * Comentar porque funciona o no el comando de compilación

## Recursos de ayuda

+ Mini tutorial interactivo de git [3]

    * [3] <https://try.github.io/>

+ Hoja de ayuda de comandos de git [4] [5]

    * [4] <https://services.github.com/on-demand/downloads/es_ES/github-git-cheat-sheet/>
    * [5] <https://about.gitlab.com/images/press/git-cheat-sheet.pdf>

+ Páginas de manual (RTFM!):

| `En terminal`          | En línea |
|:-----------------------|:---------|
| `man 7 pthreads`       | <https://linux.die.net/man/7/pthreads> |
| `man 3 pthread_create` | <https://linux.die.net/man/3/pthread_create> |
| `man 3 pthread_exit`   | <https://linux.die.net/man/3/pthread_exit> |
| `man 3 gethostbyname`  | <https://linux.die.net/man/3/gethostbyname> |
| `man 3 gethostbyaddr`  | <https://linux.die.net/man/3/gethostbyaddr> |
| `man 3 gethostname`    | <https://linux.die.net/man/3/gethostname> |
| `man 3 gethostent`     | <https://linux.die.net/man/3/gethostent> |
| `man 3 gethostid`      | <https://linux.die.net/man/3/gethostid> |

