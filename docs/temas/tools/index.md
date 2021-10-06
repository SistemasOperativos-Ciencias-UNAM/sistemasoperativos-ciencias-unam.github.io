---
# https://www.mkdocs.org/user-guide/writing-your-docs/#meta-data
date: 2021-10-06
title: Herramientas de desarrollo en C
authors:
- Andrés Leonardo Hernández Bermúdez
---

# Herramientas de desarrollo en C

## Instalar ambiente de desarrollo

Para tener un ambiente de desarrollo para C en Debian se instala el paquete [`build-essential`][paquete-build-essential]

Este paquete instala los siguientes elementos en el sistema:

- Compilador `gcc`
- Archivos de desarrollo para la biblioteca estándar de C
- Utilerías de `make`

```shell
# apt install build-essential
	...
```

También es recomendable instalar las siguientes herramientas adicionales cuando se van a compilar programas de terceros

```shell
# apt install git libtool pkg-config automake autoconf binutils file
```

## Verificar la instalación del compilador

Crear un archivo llamado [`hola.c`](files/hola.c) con el siguiente contenido

```c
#include <stdio.h>
#include <stdlib.h>

#define MENSAJE "Hola mundo"

int main(void)
{
  printf("%s\n", &MENSAJE);
  return EXIT_SUCCESS;
}
```

Verificar que se compile el programa utilizando `make`

```shell
$ make hola
cc     hola.c   -o hola
```

Revisar el tipo de archivo con `file`

```shell
# file hola.c hola
hola.c: C source, ASCII text
hola:   ELF 64-bit LSB pie executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=da39a3ee5e6b4b0d3255bfef95601890afd80709, for GNU/Linux 3.2.0, not stripped
```

Ejecutar el programa compilado

```shell
$ ./hola 
Hola mundo
```

### Verificar que el compilador soporte directivas de ligado dinámico

Descargar el archivo [`pthreads.c`](files/pthreads.c)

Compilar el programa utilizando `make` especificando las banderas para el ligado dinámico

```shell
$ LDFLAGS=-pthread make threads
cc   -pthread  threads.c   -o threads
```

Ejecutar el programa compilado

```shell
$ ./threads 
Hola mundo
```

[paquete-build-essential]: https://packages.debian.org/bullseye/build-essential
