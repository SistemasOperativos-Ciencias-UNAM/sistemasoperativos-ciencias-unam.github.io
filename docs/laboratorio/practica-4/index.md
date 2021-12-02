---
# https://www.mkdocs.org/user-guide/writing-your-docs/#meta-data
title: Distribución de trabajo en procesos e hilos
authors:
- Andrés Leonardo Hernández Bermúdez
---

# Distribución de trabajo en procesos e hilos

Práctica 4

## Objetivo

- Familiarizar al alumno con la distribución de trabajo en subprocesos e hilos de ejecución
- Crear un programa que calcule sumas de verificación de todos los archivos encontrados en un directorio utilizando subprocesos
- Crear un programa que muestre las propiedades de todos los archivos encontrados en un directorio utilizando hilos

--------------------------------------------------------------------------------

## Lineamientos

Escribir dos programas en C que cumplan con los siguientes requisitos:

### Ambos programas

- Buscar los archivos presentes en un directorio
- Definir en el código un límite de los archivos que se puedan procesar de manera simultanea
- Imprimir el resultado de la operación efectuada en la salida estándar
    - Se debe implementar de manera correcta la concurrencia para evitar que los subprocesos o hilos escriban de manera simultanea a `STDOUT`

### Programa `hashdeep`

Revisar la sección de [especificación de `hashdeep`](#hashdeep) para más detalles

- La funcionalidad es similar a la que implementa el programa [`hashdeep` de SourceForge][hashdeep-sourceforge]
- Operar únicamente en **archivos regulares** e ignorar las ligas simbólicas, archivos de socket, fifos, dispositivos de bloques y caracteres
- Para cada archivo encontrado, calcular la suma de verificación mediante subprocesos que utilicen la biblioteca de OpenSSL 
    - Existe un [código de ejemplo][ejemplo-openssl] del uso de la biblioteca EVP de OpenSSL que puede utilizarse
- Imprimir el nombre del archivo y las sumas de verificación en diferentes líneas en la salida estándar

### Programa `find-stat`

Revisar la sección de [especificación de `find-stat`](#find-stat) para más detalles

- La funcionalidad es similar a ejecutar el comando `find directorio -ls`
- Para cada archivo encontrado, lanzar un hilo que utilice la función `stat(3)` para obtener las propiedades e imprimirlas a la salida estándar

### Extra

- Implementar la opción de depuración con el argumento `-d` / `--debug` que imprima mensajes adicionales a `STDERR`
- Recibir un argumento que permita procesar un número arbitrario de archivos de manera simultanea

--------------------------------------------------------------------------------

## Recomendaciones

- Utilizar funciones de concurrencia para procesos, como las definidas en [`sysvipc(7)`][man-sysvipc] y [`sem_overview(7)`][man-sem_overview]
- Utilizar un semáforo o mutex para la concurrencia entre hilos
- Existe un [repositorio de código de ejemplo][codigo-ejemplo] que se puede utilizar para esta actividad

--------------------------------------------------------------------------------

## Restricciones

- La fecha límite de entrega es el **lunes 13 de diciembre de 2021** a las 23:59 horas
- Esta actividad debe ser entregada **por equipo** de acuerdo al [flujo de trabajo para la entrega de tareas y prácticas][flujo-de-trabajo]
    - Crear un _merge request_ en el [repositorio de tareas][repo-tareas] para entregar la actividad

--------------------------------------------------------------------------------

## Entregables

Se deben entregar los siguientes elementos en la carpeta `entregas/practica-4`

- Documentación en el archivo `README.md`
- Código de los programas en C
- Archivo `Makefile` para compilación
- _Script_ de _shell_ para pruebas
- Bitácoras de compilación y pruebas del programa en texto plano
    - No entregar capturas de pantalla ni archivos PDF

--------------------------------------------------------------------------------

## Especificación

### Versión del programa

Imprimir la versión del programa, el nombre del equipo y la información de los autores (nombre y número de cuenta) cuando se pase el argumento `-V` o `--version`.

```text
$ programa --version
programa v0.0.1 (Sistemas Operativos - Equipo-AAAA-BBBB-CCCC)
1234657890	Nombre Apellido
	...
```

El código de salida para este caso debe ser `-2`

### Función de ayuda

Implementar una función de ayuda que muestre la versión del programa y que explique los argumentos que recibe.

El código de salida para este caso debe ser `-3`

### hashdeep

- El proceso padre busca todos los archivos dentro de un directorio que se pasa como parámetro
    - Operar únicamente en **archivos regulares** e ignorar las ligas simbólicas, archivos de socket, fifos, dispositivos de bloques y caracteres
- Para cada archivo encontrado
    - El proceso padre lanza varios subprocesos que calculan de manera independiente la suma de verificación del archivo 
    - Cada subproceso calcula la suma de verificación utilizando un algoritmo de los que se listan a continuación
        - `md5`, `sha1`, `sha224`, `sha256`, `sha384`, `sha512`
    - Utilizar **por lo menos tres** algoritmos para calcular la suma de verificación de cada archivo encontrado
- Se debe implementar de manera correcta la concurrencia para evitar que los subprocesos escriban de manera simultanea a `STDOUT`
    - **Opción A**:
        - El proceso padre lanza los subprocesos que calcula la suma de verificación
            - El proceso padre espera a que los subprocesos terminen su ejecución
            - Al finalizar cada subproceso, regresa la suma de verificación al padre
        - El proceso padre imprime el nombre del archivo y las sumas de verificación a `STDOUT`
    - **Opción B**:
        - El proceso padre imprime el nombre del archivo a `STDOUT`
        - El proceso padre lanza los subprocesos que calcula la suma de verificación
            - Al finalizar cada subproceso, imprime la suma de verificación a `STDOUT`

### find-stat

- El proceso padre busca todos los archivos dentro de un directorio que se pasa como parámetro
    - Opera en **todos los tipos de archivo** que se encuentren: directorios, archivos regulares, ligas simbólicas, archivos de socket, fifos, dispositivos de bloques y caracteres
- El programa debe ser capaz de procesar varios archivos de manera simultanea y coordinar las impresiones de cada hilo a `STDOUT`
- Para cada archivo y directorio encontrado
    - El proceso lanza un hilo que utilice la función `stat(3)` para obtener las propiedades del archivo
    - El hilo imprime las propiedades del archivo a `STDOUT`
- Se debe implementar de manera correcta la concurrencia para evitar que los hilos escriban de manera simultanea a `STDOUT`

--------------------------------------------------------------------------------

### Ejemplos de ejecución

La ejecución para mostrar la versión de los programas y el texto de ayuda es la misma que se ha manejado con anterioridad.

#### Ejecución de `hashdeep`

En ese caso se están calculando las sumas de verificación `md5`, `sha1` y `sha256` de los archivos muestra.

```text
$ hashdeep ./
null
d41d8cd98f00b204e9800998ecf8427e
da39a3ee5e6b4b0d3255bfef95601890afd80709
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855

eicar
44d88612fea8a8f36de82e1278abb02f
3395856ce81f2b7382dee72602f798b642f14140
275a021bbfb6489e54d471899f7db9d1663fc695ec2fe2a2c4538aabf651fd0f

programa.c
418126f71694f481c30dae44b682ec6c
f8e0a1a6897a92ee3468eafd7245b2062722e6cb
efaae7eabc4ac20ab97710cf7684a86361758d4a5a1f107dc7569fded2955eb0
```

#### Ejecución de `find-stat`

En este caso se están resolviendo el nombre del propietario, el grupo y se convierten los permisos octales al modo simbólico.

```text
$ find ./ -ls
  3125845      0 drwxr-xr-x   7 tonejito  users       224 Dec  2 00:00 ./
  3150095      0 -rw-r--r--   1 tonejito  users         0 Dec  2 00:01 ./null
  3127893      4 -rw-r--r--   1 tonejito  users        68 Dec  2 00:02 ./eicar
  3149488      4 -rw-r--r--   1 tonejito  users        31 Dec  2 01:02 ./programa.c
```

--------------------------------------------------------------------------------

[flujo-de-trabajo]: https://sistemasoperativos-ciencias-unam.gitlab.io/2022-1/tareas-so/workflow/
[repo-tareas]: https://gitlab.com/SistemasOperativos-Ciencias-UNAM/2022-1/tareas-so.git
[codigo-ejemplo]: https://gitlab.com/SistemasOperativos-Ciencias-UNAM/codigo-ejemplo.git
[ejemplo-openssl]: https://gitlab.com/SistemasOperativos-Ciencias-UNAM/codigo-ejemplo/-/tree/master/openssl
[hashdeep-sourceforge]: http://md5deep.sourceforge.net/start-hashdeep.html
[man-sysvipc]: https://man7.org/linux/man-pages/man7/svipc.7.html
[man-sem_overview]: https://man7.org/linux/man-pages/man7/sem_overview.7.html
