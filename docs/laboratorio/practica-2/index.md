---
# https://www.mkdocs.org/user-guide/writing-your-docs/#meta-data
title: Propiedades de un proceso
authors:
- Andrés Leonardo Hernández Bermúdez
---

# Propiedades de un proceso

Práctica 2

## Objetivo

- Familiarizar al alumno con los mecanismos estándar para recolectar información sobre los procesos que se ejecutan en el sistema operativo
- Crear algunos programas que demuestren el uso de llamadas al sistema y el uso del directorio `/proc` para obtener información sobre los procesos

Se puede consultar la lista de llamadas al sistema en el sitio [linux.die.net][linux-syscalls-man]

--------------------------------------------------------------------------------

## Lineamientos

Escribir dos programas en C que cumplan con los siguientes requisitos:

`check_procs`

- Cuenta el número de procesos en ejecución en el sistema

`check_proc`

- Obtiene la información de proceso de si mismo utilizando llamadas al sistema

`check_pid`

- Obtiene la información de un proceso utilizando el directorio `/proc/<PID>`

--------------------------------------------------------------------------------

## Restricciones

- Utilizar el programa `esqueleto` que se desarrolló en la [tarea-1]
- La fecha límite de entrega es el **domingo 21 de noviembre de 2021** a las 23:59 horas
- Esta práctica debe ser entregada **por equipo** de acuerdo al [flujo de trabajo para la entrega de tareas y prácticas][flujo-de-trabajo]
    - Crear un _merge request_ en el [repositorio de tareas][repo-tareas] para entregar la actividad

--------------------------------------------------------------------------------

## Entregables

Se deben entregar los siguientes elementos en la carpeta `entregas/practica-2`

- Documentación en el archivo `README.md`
- Código de los programas en C
- Archivo `Makefile` para compilación
- _Script_ de _shell_ para pruebas
- Bitácoras de compilación y pruebas del programa en texto plano
    - No entregar capturas de pantalla
- Implementar la opción `-v` / `--verbose` para imprimir mensajes de información a `STDERR`

### Extra

- Implementar la opción `-d` / `--debug` para imprimir mensajes de depuración a `STDERR`

--------------------------------------------------------------------------------

## Especificación

### Programa `check_procs`

Cuenta el número de procesos en ejecución en el sistema
- El número de procesos se puede contar utilizando los directorios presentes en el sistema de archivos virtuales `/proc`
- Cada proceso tiene un directorio asociado en `/proc/<PID>`

**Argumentos**

- `-w` / `--warning` `NUM`
    - Si el número de procesos es menor a este número, el estado debe ser marcado como `OK`
    - Representa el número de procesos en el que el estado debe ser marcado como `WARNING`
- `-c` / `--critical` `NUM`
    - Representa el número de procesos en el que el estado debe ser marcado como `CRITICAL`

**Estados del programa**

| Estado     | Número de procesos                          | Código de salida | Mensaje  |
|:----------:|:-------------------------------------------:|:----------------:|:--------:|
|`OK`        | Mayor a cero y menor que `-w`               | `0`              | `STDOUT` |
|`WARNING`   | Mayor o igual que `-w`, pero menor que `-c` | `1`              | `STDOUT` |
|`CRITICAL`  | Mayor o igual que `-c`                      | `2`              | `STDOUT` |
|`UNKNOWN`   | Cero                                        | `3`              | `STDOUT` |
|`FAILURE`   | Error de ejecución                          | `-4`             | `STDERR` |

**Salida del programa**

```text
<ESTADO>: procesos: <NÚMERO-DE-PROCESOS>
```

### Programa `check_proc`

- Obtiene la información de proceso de si mismo utilizando llamadas al sistema
- Utilizar [llamadas al sistema][linux-syscalls-man] como las siguientes para obtener información del proceso actual:
    - `getpid(2)`, `getppid(2)`, `getcwd(2)`, `getcpu(2)`, `getuid(2)`, `getgid(2)`, `getpgid(2)`, `getpgrp(2)`, `getpriority(2)`, `getsid(2)`, `gettid(2)`, `sched_*(2)`, etc.
- Obtener la línea de comandos del programa, así como la lista de variables de entorno

**Argumentos**

- `-v` / `--verbose`: Muestra la lista de variables de entorno del programa al final de la salida

**Estados del programa**

El estado del programa siempre va a ser `OK` y el código de salida es `0` debido a que un proceso siempre puede obtener información de si mismo

**Salida del programa**

```text
OK	nombre-del-programa
args:	%s
PID:	%d
PPID:	%d
UID:	%d
GID:	%d
CWD:	%s
...
```

El programa muestra la lista de variables de entorno del programa al final de la salida si se pasó la opción `-v` / `--verbose`

### Programa `check_pid`

Utiliza los archivos dentro del directorio `/proc/<PID>` para obtener la información de un proceso:

- Línea de comandos
- Variables de entorno
- Directorio de trabajo
- Ruta hacia el programa
- Información de los descriptores de archivo (directorio `/proc/<PID>/fd`)
- Raíz del sistema de archivos
- Información sobre la memoria que utiliza el programa

**Recomendaciones**

- Este programa lee archivos desde el directorio `/proc/<PID>` por lo que se deben utilizar funciones como las siguientes para el manejo de archivos
    -  `chdir(3)`, `fopen(3)`, `fclose(3)`, `getdirentries(3)`, `readdir(3)`, `stat(3)`, `scandir(3)`, etc.
- Varios de los archivos tienen campos delimitados por `\0` y es necesario convertir ese caracter a un espacio en blanco "` `" para poder mostrar la información de manera correcta
- La información que contienen los archivos dentro de `/proc/<PID>` no tiene una longitud determinada, se sugiere utilizar un _buffer_ de lectura de un tamaño fijo e inicializarlo con `bzero(3)` o `memset(3)` antes de utilizarlo

**Argumentos**

- `-p` / `--pid` `NUM`: Indica el identificador del proceso que se debe analizar
    - Si este argumento no está presente, utilizar el directorio `/proc/self` para obtener la información del proceso actual
- `-v` / `--verbose`: Muestra la lista de variables de entorno del programa al final de la salida

**Estados del programa**

| Estado     | Condición                                                            | Código de salida |
|:----------:|:---------------------------------------------------------------------|:----------------:|
|`OK`        | Se pudo leer el directorio `/proc/<PID>` y se muestra la información | `0`              |
|`UNKNOWN`   | Otro error de ejecución                                              | `3`              |
|`FAILURE`   | No se pudo leer el directorio `/proc/<PID>`                          | `-4`             |

- El estado `FAILURE` imprime un mensaje en la **salida de error** (`STDERR`).

**Salida del programa**

```text
OK	nombre-del-programa
args:	%s
PID:	%d
PPID:	%d
UID:	%d
GID:	%d
CWD:	%s
...
```

El programa muestra la lista de variables de entorno del programa al final de la salida si se pasó la opción `-v` / `--verbose`

--------------------------------------------------------------------------------

[flujo-de-trabajo]: https://sistemasoperativos-ciencias-unam.gitlab.io/2022-1/tareas-so/workflow/
[repo-tareas]: https://gitlab.com/SistemasOperativos-Ciencias-UNAM/2022-1/tareas-so.git
[linux-syscalls-man]: https://linux.die.net/man/2/
[tarea-1]: ../tarea-1/
