---
# https://www.mkdocs.org/user-guide/writing-your-docs/#meta-data
title: Programa esqueleto
authors:
- Andrés Leonardo Hernández Bermúdez
---

# Programa esqueleto en C

Tarea 1

## Objetivo

- Familiarizar al alumno con los mecanismos estándar de entrada y salida de un proceso en Linux
- Crear un programa esqueleto que se utilizará en las demás tareas y prácticas

Se puede utilizar el [código de muestra][skeleton-c] del tema [_elementos de entrada y salida de un programa_][skeleton] como base para elaborar esta tarea

--------------------------------------------------------------------------------

## Lineamientos

Escribir un progrma en C que cumpla con los siguientes requisitos:

- Lee argumentos de entrada
- Lee variables de entorno
- Lee desde la entrada estándar
- Imprime mensajes a la salida estándar
- Imprime mensajes a la salida de error
- Regresa un código de salida exitoso o no exitoso dependiendo de las condiciones de ejecución

--------------------------------------------------------------------------------

# Restricciones

- La fecha límite de entrega es el **domingo 07 de noviembre de 2021** a las 23:59 horas
- Esta práctica debe ser entregada **por equipo** de acuerdo al [flujo de trabajo para la entrega de tareas y prácticas][flujo-de-trabajo]
    - Crear un _merge request_ en el [repositorio de tareas][repo-tareas] para entregar la actividad

--------------------------------------------------------------------------------

## Entregables

Se deben entregar los siguientes elementos en la carpeta `entregas/tarea-1`

- Documentación en el archivo `README.md`
- Código del programa en C
- Archivo `Makefile` para compilación
- _Script_ de _shell_ para pruebas
- Bitácoras de compilación y pruebas del programa en texto plano
    - No entregar capturas de pantalla

### Extra

- Incluir el uso de `CFLAGS` y `LDFLAGS` dentro del `Makefile` para compilar una versión estática del binario además de un binario con ligado dinámico
- Hacer uso del programa `strip` para quitar los símbolos innecesarios del programa
- Analizar los programas compilados con `file`, `ldd` y `readelf` o `dumpelf`
- Entregar las bitácoras de compilación y análisis en el reporte como código embebible de [asciinema][asciinema-start]
- Grabar las bitácoras de compilación y análisis con `asciinema` e incluir el [código embebible][asciinema-embed] en el archivo `README.md`

--------------------------------------------------------------------------------

## Especificación

### Mensaje breve de uso del programa

Cuando el programa se ejecute sin argumentos, deberá escribir un mensaje breve que indique la manera en la que se utiliza.

```text
$ esqueleto
esqueleto: Could not parse arguments
Usage:
 esqueleto <integer state> [optional text]
```

El código de salida para este caso debe ser `-1`

### Versión del programa

Imprimir la versión del programa, el nombre del equipo y la información de los autores (nombre y número de cuenta) cuando se pase el argumento `-V` o `--version`.

```text
$ esqueleto --version
esqueleto v0.0.1 (Sistemas Operativos - Equipo-AAAA-BBBB-CCCC)
1234657890	Nombre Apellido
	...
```

El código de salida para este caso debe ser `-2`

### Función de ayuda

Cuando el programa se ejecute con la opción de línea de comandos `-h` o `--help` se deberá mostrar la ayuda del programa.

```text
$ esqueleto --help
esqueleto v0.0.1 (Sistemas Operativos - Equipo-AAAA-BBBB-CCCC)
1234657890	Nombre Apellido
	...

This plugin will simply return the state corresponding to the numeric value
of the <state> argument with optional text

Usage:
 esqueleto <integer state> [optional text]

Options:
 -h, --help
    Print detailed help screen
 -V, --version
    Print version information
```

El código de salida para este caso debe ser `-3`

### Procesamiento de argumentos

El programa debe recibir un argumento obligatorio de tipo entero y un argumento opcional de tipo texto.

#### Primer argumento (obligatorio)

El primer argumento indica el código de salida que debe tener el programa:

| Estado     | Argumento    | Código de salida | Mensaje  |
|:----------:|:------------:|:----------------:|:--------:|
|`OK`        | `0`          | `0`              | `STDOUT` |
|`WARNING`   | `1`          | `1`              | `STDOUT` |
|`CRITICAL`  | `2`          | `2`              | `STDOUT` |
|`UNKNOWN`   | `3`          | `3`              | `STDOUT` |
|`FAILURE`   | (otro valor) | `-4`             | `STDERR` |

Se debe imprimir un mensaje a la **salida de error** si el argumento de entrada tiene un valor que no entre en el rango `[0..3]` y regresar el código de salida `-4`.

```text
FAILURE: Status %d is not a supported state
```

#### Segundo argumento (opcional)

El segundo argumento representa un mensaje corto que se debe de imprimir a la salida estándar.

El valor de este argumento también podrá ser leído desde una variable de entorno llamada `MESSAGE` o desde la entrada estándar.

- Si no hay argumento ni variable de entorno, entonces no hay texto que mostrar.
- En caso de que el argumento no esté definido, intentar leer la variable de entorno.
- Si el argumento está definido, ignorar la variable de entorno.
    - Si el argumento está definido y es igual a `-`, leer el texto desde `STDIN`
    - Si el argumento está definido y no es igual a `-`, entonces es el mensaje que se debe mostrar.

Este valor tiene una longitud máxima de 70 caracteres, el mensaje debe ser truncado si excede esta longitud.

--------------------------------------------------------------------------------

### Ejemplos de ejecución

#### Sin mensaje

Ejemplo de ejecución si no se proporciona el argumento opcional:

- Se ejecuta `echo $?` para imprimir el código de salida del programa

```text
$ esqueleto -1 ; echo $?
FAILURE: Status -1 is not a supported state
-4

$ esqueleto 0 ; echo $?
OK
0

$ esqueleto 1 ; echo $?
WARNING
1

$ esqueleto 2 ; echo $?
CRITICAL
2

$ esqueleto 3 ; echo $?
UNKNOWN
3

$ esqueleto 4 ; echo $?
FAILURE: Status 4 is not a supported state
-4
```

#### Mensaje desde argumento

Ejemplo cuando se especifica el argumento opcional en línea de comandos:

- Se ejecuta `echo $?` para imprimir el código de salida del programa

```text
$ esqueleto -1 "Test" ; echo $?
FAILURE: Status -1 is not a supported state
-4

$ esqueleto 0 "Test" ; echo $?
OK: Test
0

$ esqueleto 1 "Test" ; echo $?
WARNING: Test
1

$ esqueleto 2 "Test" ; echo $?
CRITICAL: Test
2

$ esqueleto 3 "Test" ; echo $?
UNKNOWN: Test
3

$ esqueleto 4 "Test" ; echo $?
FAILURE: Status 4 is not a supported state
-4
```

#### Mensaje desde variable de entorno

Ejemplo cuando se especifica el argumento opcional como variable de entorno:

- Se ejecuta `echo $?` para imprimir el código de salida del programa

```text
$ MESSAGE="Test" esqueleto -1 ; echo $?
FAILURE: Status -1 is not a supported state
-4

$ MESSAGE="Test" esqueleto 0 ; echo $?
OK: Test
0

$ MESSAGE="Test" esqueleto 1 ; echo $?
WARNING: Test
1

$ MESSAGE="Test" esqueleto 2 ; echo $?
CRITICAL: Test
2

$ MESSAGE="Test" esqueleto 3 ; echo $?
UNKNOWN: Test
3

$ MESSAGE="Test" esqueleto 4 ; echo $?
FAILURE: Status 4 is not a supported state
-4
```

#### Mensaje desde entrada estándar

Ejemplo cuando se especifica el argumento opcional desde la entrada estándar:

- Se ejecuta `echo $?` para imprimir el código de salida del programa

```text
$ echo "Test" | esqueleto -1 - ; echo $?
FAILURE: Status -1 is not a supported state
-4

$ echo "Test" | esqueleto 0 - ; echo $?
OK: Test
0

$ echo "Test" | esqueleto 1 - ; echo $?
WARNING: Test
1

$ echo "Test" | esqueleto 2 - ; echo $?
CRITICAL: Test
2

$ echo "Test" | esqueleto 3 - ; echo $?
UNKNOWN: Test
3

$ echo "Test" | esqueleto 4 - ; echo $?
FAILURE: Status 4 is not a supported state
-4
```

--------------------------------------------------------------------------------

[nagios-check_dummy]: https://github.com/nagios-plugins/nagios-plugins/blob/master/plugins/check_dummy.c
[monitoring_plugins-check_dummy]: https://github.com/monitoring-plugins/monitoring-plugins/blob/master/plugins/check_dummy.c

[flujo-de-trabajo]: https://sistemasoperativos-ciencias-unam.gitlab.io/2022-1/tareas-so/workflow/
[repo-tareas]: https://gitlab.com/SistemasOperativos-Ciencias-UNAM/2022-1/tareas-so.git
[asciinema-start]: https://asciinema.org/docs/getting-started
[asciinema-embed]: https://asciinema.org/docs/embedding
[skeleton]: /temas/skeleton/
[skeleton-c]: /temas/skeleton/programa.c
