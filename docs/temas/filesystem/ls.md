---
# https://www.mkdocs.org/user-guide/writing-your-docs/#meta-data
title: Listado de directorios
authors:
- Andrés Leonardo Hernández Bermúdez
---

# Listado de directorios en C

Existen varias funciones en la biblioteca estándar de C para el manejo de directorios del sistema de archivos:

| Función        | Descripción      |
|:--------------:|:-----------------|
| `scandir(3)`   | Busca entradas en un directorio
| `readdir(3)`   | Lee un directorio
| `opendir(3)`   | Abre la referencia a un directorio
| `closedir(3)`  | Cierra la referencia a un direcorio
| `dirfd(3)`     | Obtiene un descriptor de archivo hacia un directorio
| `rewinddir(3)` | Reinicia la posición del apuntador de directorio al principio
| `seekdir(3)`   | Establece la posición de la siguiente llamada a `readdir(3)`
| `telldir(3)`   | Regresa la posición actual en el contenido del directorio

Algunas de las funciones tratan al directorio como un apuntador hacia una estructura de tipo directorio, similar a `fopen(3)` y otras funciones dan un tratamiento mas abstracto que enmascara los descriptores y regresa una estructura con el contenido del directorio.

## Estructuras de datos en C

Cuando se trabaja con directorios se utilizan un par de estructuras en C:

### Entrada de directorio

La biblioteca estándar de C provee una estructura que tiene el contenido de un directorio en el archivo de cabecera [`<dirent.h>`][dirent-h-man].

```c
#include <dirent.h>

struct dirent {
  ino_t          d_ino;       /* número de ínodo */
  off_t          d_off;       /* número de bytes hasta la siguiente entrada dirent */
  unsigned short d_reclen;    /* longitud de este registro */
  unsigned char  d_type;      /* tipo de archivo, no es soportado 
                                 por todos los sistemas de archivos */
  char           d_name[256]; /* nombre de archivo (255 bytes) */
};
```

### Estructura de tipo directorio

La biblioteca estándar de C define un estructura llamada `DIR` en el archivo de cabecera [`<dirent.h>`][dirent-h-man].

```nc
#include <dirent.h>

typedef struct __dirstream DIR;
```

La definición de la estructura `__dirstream` se abstrae al usuario y se define en el archivo de cabecera [`<dirstream.h>`][dirstream-glibc-mirror].

```c
#include <dirstream.h> /* implícito */

struct __dirstream
{
  int fd;                     /* Descriptor de archivo */

  __libc_lock_define (, lock) /* Mutex para prevenir interbloqueo */

  size_t allocation;          /* Espacio asignado a este bloque*/
  size_t size;                /* Tamaño de este bloque */
  size_t offset;              /* Número de bytes hasta la siguiente entrada */

  off_t filepos;              /* Posición de la siguiente entrada */

  int errcode;                /* Código de error */

  /* Bloque de directorio */
  char data[0] __attribute__ ((aligned (__alignof__ (long double))));
};
```

## Listar el contenido de un directorio

Para obtener la lista de archivos contenidos en un directorio se debe declarar la lista de tipo `dirent` y una variable que contendrá el número de elementos contenidos en el directorio.

```c
struct dirent **namelist;
int n=0;
```

Después se utiliza la función `scandir(3)` para obtener la lista de archivos contenidos en el directorio.

```c
n = scandir(path, &namelist, NULL, alphasort);
```

En este punto la lista `namelist` contiene las entradas del directorio, cada entrada tiene dos campos principales:

- `ino_t d_ino;` : Número de inodo correspondiente al archivo
- `char  d_name[256];` : Nombre del archivo

Utilizando la ruta del directorio actual y el nombre del archivo, se puede llamar a la función `stat(3)` para obtener información adicional del archivo y listar todas sus propiedades como propietario, grupo, tamaño, permisos, etc.

El código completo del programa `ls` se encuentra en el repositorio de [código de ejemplo][ls-c].

--------------------------------------------------------------------------------

[ls-c]: https://gitlab.com/SistemasOperativos-Ciencias-UNAM/codigo-ejemplo/-/blob/master/filesystems/ls.c
[scandir-man]: https://linux.die.net/man/3/scandir
[readdir-man]: https://linux.die.net/man/3/readdir
[stat-man]: https://linux.die.net/man/3/stat
[fstat-man]: https://linux.die.net/man/2/fstat
[dirent-h-man]: https://man7.org/linux/man-pages/man0/dirent.h.0p.html
[dirstream-glibc]: https://sourceware.org/git/?p=glibc.git;a=blob;f=sysdeps/unix/sysv/linux/dirstream.h;h=b5e1db8db0f89cea5487583a090518f802420fa1;hb=refs/heads/master
[dirstream-glibc-mirror]: https://gitlab.com/SistemasOperativos-Ciencias-UNAM/programas/glibc/-/blob/master/sysdeps/unix/sysv/linux/dirstream.h
