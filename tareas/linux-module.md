# Módulos para el _kernel_ Linux

## Objetivo

## Lineamientos

## Restricciones

## Requisitos

Revisar la documentación del kernel para la versión del kernel que se está ejecutando

```
$ uname -r
4.9.0-8-amd64
```

+ Se pueden tomar los dos primeros dígitos de la versión del kernel para revisar la documentación (ej. 4.9 o 4.15)
+ Agregar el número de versión al final de la URL para ir a la documentación específica:

+ URLs de documentación para la versión 4.9

  *  <https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/?h=v4.9>
  *  <https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/Documentation?h=v4.9>
  *  <https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/include/linux?h=v4.9>

## Lista de módulos

+ `/dev/date`
+ `/dev/uuid`
+ `/dev/one`

## Descripción

### `/dev/date`

+ Regresa la fecha en segundos desde el tiempo EPOCH de UNIX cada vez que se lee el archivo especial `/dev/date`

+ La salida es similar a ejecutar el comando `date` con el parámetro `'+%s'`:

```
$ date '+%s'
1542844800
```

+ Ejemplo:

```
$ cat /dev/date
1542848400
```

+ Ajustar los permisos para que todos los usuarios puedan leer el archivo especial `/dev/date`:

```
$ ls -la /dev/date
crw-rw-rw-  1  root root  10, 51  Nov 21 18:00  /dev/date
```

+ <https://en.wikipedia.org/wiki/Unix_time>
+ <https://linux.die.net/man/1/date>
+ <https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/include/linux/time.h>
+ <https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/include/linux/time64.h>
+ <https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/include/linux/ktime.h>

### `/dev/uuid`
\
+ Regresa un [UUID](# "Universally Unique IDentifier") cada vez que se lee el archivo especial `/dev/uuid`

+ El módulo recibe un argumento que indica el tipo de versión de UUID que se debe generar

  * Las versiones de UUID aceptadas son `1` y `4`

+ La salida es similar a ejecutar el comando `uuid` con el parámetro `-v 1` o `-v 4`

```
$ uuid -v 1
83e1475e-eead-11e8-8c42-a77eedfde652

$ uuid -v 4
f86f9a71-525a-4617-b3be-bc4c6c59902c
```

Ejemplo:

+ Pasando el argumento para generar UUID versión 1

```
# insmod uuid.ko version=1

$ cat /dev/uuid
c5d7db46-eead-11e8-b487-939414c846bb
```

+ Pasando el argumento para generar UUID versión 4

```
# insmod uuid.ko version=4

$ cat /dev/uuid
6604318f-d03d-4649-874a-df569bbafc77
```

+ Ajustar los permisos para que todos los usuarios puedan leer el archivo especial `/dev/uuid`:

```
$ ls -la /dev/uuid
crw-rw-rw-  1  root root  10, 51  Nov 21 18:00  /dev/date
```

+ <https://en.wikipedia.org/wiki/UUID>
+ <https://linux.die.net/man/1/uuid>
+ <https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/include/linux/uuid.h>
+ <http://www.tldp.org/LDP/lkmpg/2.6/html/x323.html>

### `/dev/one`

+ Simular la funcionalidad de `/dev/zero` utilizando un módulo que recibe un parámetro que va en el rango de `0x00` a `0xFF`
+ El parámetro introducido será regresado en cada llamada de lectura (`read`) al módulo

+ Para generar un archivo llamado `arch1` con 1 byte 0x01 se debe hacer lo siguiente:

  * Cargar el módulo:

```
# insmod devone.ko val=0x01
```

  * Crear el archivo de muestra con `dd`

```
$ dd if=/dev/one of=arch1 bs=1 count=1
1+0 records in
1+0 records out
1 byte (1 B) copied, 0.000216371 s, 4.6 kB/s

$ ls -la arch1
-rw-r--r--  1  tonejito users  1  Nov 21 19:00  arch1
```

  * Ver el contenido del archivo con `hexdump`, aquí se ve que el único byte presente es `0x01`

```
$ hexdump -C arch1 
00000000  01                                                |.|
00000001
```

+ De manera análoga se puede crear el archivo `arch2` con 1KB de bytes `0x01`

```
$ dd if=/dev/one bs=1024 count=1 | hexdump -C
1+0 records in
1+0 records out
1024 bytes (1.0 kB) copied, 5.2329e-05 s, 19.6 MB/s

$ hexdump -C arch2 
00000000  01 01 01 01 01 01 01 01  01 01 01 01 01 01 01 01  |................|
*
00000400

```

+ <https://linux.die.net/man/1/dd>
+ <https://linux.die.net/man/1/hexdump>
+ <http://www.tldp.org/LDP/lkmpg/2.6/html/x323.html>

