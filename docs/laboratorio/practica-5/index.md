---
# https://www.mkdocs.org/user-guide/writing-your-docs/#meta-data
title: Comunicación con sockets
authors:
- Andrés Leonardo Hernández Bermúdez
---

# Comunicación con sockets

Práctica 5

## Objetivo

- Familiarizar al alumno con el uso de sockets para establecer comunicación entre dos equipos
- Implementar un servidor web orientado a procesos e hilos para transmitir información a través del protocolo HTTP

--------------------------------------------------------------------------------

## Restricciones

- La fecha límite de entrega es el **domingo 09 de enero de 2022** a las 23:59 horas
- Esta actividad debe ser entregada **por equipo** de acuerdo al [flujo de trabajo para la entrega de tareas y prácticas][flujo-de-trabajo]
    - Crear un _merge request_ en el [repositorio de tareas][repo-tareas] para entregar la actividad

--------------------------------------------------------------------------------

## Entregables

Se deben entregar los siguientes elementos en la carpeta `entregas/practica-5`

- Documentación en el archivo `README.md`
- Código de los programas en C
- Archivo `Makefile` para compilación
- _Script_ de _shell_ para pruebas
- Bitácoras de compilación y pruebas del programa en texto plano
    - No entregar capturas de pantalla ni archivos PDF

--------------------------------------------------------------------------------

### Petición HTTP

Para esta actividad, se espera que el **cliente** envíe los siguientes elementos en la petición HTTP:

- El método puede ser `GET` o `HEAD`
    - Se lanza un error `405` si el cliente especifica algún otro método
- Tiene cabeceras
    - El cliente especifica la cabecera `Host` con la dirección IP y puerto del servidor
    - Cada línea de las cabeceras se termina con `\r\n`
    - Al final de las cabeceras se debe imprimir el separador `\r\n`
- La petición no tiene cuerpo del mensaje

```text
GET / HTTP/1.0\r\n
Host: 127.0.0.1:80\r\n
```

```text
HEAD /directorio/archivo HTTP/1.0\r\n
Host: 192.0.2.1:8080\r\n
```

### Respuesta HTTP

La respuesta HTTP tiene una sección de cabeceras y opcionalmente una sección con el cuerpo del mensaje.

- Las respuestas HTTP deben contener por lo menos las siguientes cabeceras:
    - `Server` : Nombre del _software_ de servidor web
    - `Date` : Fecha en formato [RFC 822][rfc-822] o [RFC 7231][rfc-7231]
    - `Connection: close` : Indica al cliente que únicamente se va a atender una petición en esta conexión

#### Respuesta `GET`

- La respuesta HTTP tiene una sección de cabeceras y una sección con el cuerpo
- Cada línea de las cabeceras se termina con `\r\n`
- La sección de cabeceras se separa del cuerpo de la respuesta utilizando una línea en blanco con el separador `\r\n`
- Adicionalmente, la respuesta del método `GET` debe contener las siguientes cabeceras:
    - `Content-Length` : Longitud del contenido en bytes
    - `Content-Type` : Tipo de contenido MIME y codificación (para formatos de texto)

Ejemplo de respuesta a una petición `GET`:

```text
HTTP/1.0 200 OK
Server: httpd/0.0.1 (procs)
Date: Sun, 12 Dec 2021 01:02:03
Content-Length: 11
Content-Type: text/plain
Connection: Close

Hola mundo
```

#### Respuesta `HEAD`

- Se debe de imprimir una línea en blanco para terminar el bloque de cabeceras
- Cada línea de las cabeceras se termina con `\r\n`
- La respuesta `HEAD` no tiene cuerpo, por lo que se debe cerrar la conexión después de imprimir las cabeceras e imprimir el separador `\r\n`

- Adicionalmente, la respuesta del método `HEAD` debe contener las siguientes cabeceras que representan campos regresados por la llamada al sistema `stat(2)`:

    - Nombre del archivo
    - Inodo donde se encuentra
    - Tamaño en bytes
    - UID y GID propietarios del archivo
    - Modo octal de permisos
    - Fecha de modificación (`mtime`)

Ejemplo de respuesta a una petición `HEAD`:

```text
HTTP/1.0 200 OK
Server: httpd/0.0.1 (threads)
Date: Sun, 12 Dec 2021 02:03:04
Content-Length: 0
Connection: Close
name: directorio/archivo
inode: 2147483647
size: 2048
uid: 1000
gid: 100
mode: 640
mtime: Sun, 12 Dec 2021 00:01:02

```

#### Página de índice

Cuando el cliente pide un directorio, el servidor debe buscar si existe alguno de los siguientes archivos y regresarlo como la _página de índice_:

- `index.html`
- `index.htm`
- `index.txt`

Se regresa un error `400` cuando el cliente pide un directorio y no hay página de índice.

--------------------------------------------------------------------------------

## Lineamientos

Escribir dos programas en C que cumplan con los siguientes requisitos:

### Conceptos

- `DocumentRoot`: Raíz del sitio web. Desde este directorio se servirán los recursos (archivos) que provee el servidor web

- _Página de índice_ : Página que se regresa cuando el cliente pide un directorio

### Ambos programas

Revisar la sección de [especificación](#especificacion) para más detalles

- Definir en el código un límite del número de clientes que se puedan procesar de manera simultanea
- Leer el puerto de conexión desde el parámetro `-p <puerto>` o `--port <puerto>`
- Leer la ruta del directorio raíz del sitio desde el parámetro `-r <directorio>` o `--root <directorio>`
- El proceso principal o proceso padre debe escribir en una bitácora un registro de cada petición que reciba de los clientes
    - La ruta del archivo de bitácora se lee desde el parámetro `-l archivo` o `--log archivo`
    - La bitácora se debe imprimir a `STDERR` si se recibe la opción `-d` o `--debug` de línea de comandos
    - El formato de la bitácora sera [`common`][logformat-common]
        - [Más información][logformat-common-wikipedia] sobre el contenido de los campos
    - Se debe implementar de manera correcta la concurrencia para evitar que los subprocesos o hilos escriban de manera simultanea a `STDOUT`
- Una vez que el proceso o hilo reciba la petición del cliente:
    - En caso de que el cliente pida un archivo, buscarlo en una ruta **relativa** a la raíz del sitio y servir el archivo o regresar un error
    - Operar solo con **directorios** y **archivos regulares** e ignorar cualquier otro tipo de archivo

- El servidor web implementa un subconjunto del protocolo `HTTP/1.0` con los siguientes métodos: `GET` y `HEAD`

#### Conexión HTTP con sockets TCP

| ![](img/http-conexion-socket.png) |
|:---------------------------------:|
| Funcionamiento de la conexión TCP para el protocolo HTTP

#### Servidor web orientado a procesos

- El proceso padre inicializa el socket TCP y lo pone en estado de escucha
- Cuando un cliente se conecta, el proceso padre crea un nuevo subproceso para atenderlo
- El subproceso recibe la petición del cliente, la atiende, finaliza la conexión y termina
    - Se debe escribir a la bitácora un registro de cada petición que se reciba de los clientes

#### Servidor web orientado a hilos

- El proceso principal inicializa el socket TCP y lo pone en estado de escucha
- Cuando un cliente se conecta, el proceso principal crea un hilo para atenderlo
- El nuevo hilo recibe la petición del cliente, la atiende, finaliza la conexión y termina
    - Se debe escribir a la bitácora un registro de cada petición que se reciba de los clientes

### Extra

- Recibir un argumento que permita procesar un número arbitrario de clientes de manera simultanea
    - Especificar el número máximo de clientes simultaneos con el argumento `--clients <NUM>`
- Unificar los dos programas en uno solo que permita elegir si se van a utilizar procesos o hilos para atender a los clientes
    - Seleccionar el modo de procesos al especificar la opción de línea de comandos `--procs` 
    - Seleccionar el modo de hilos al especificar la opción de línea de comandos `--threads` 

--------------------------------------------------------------------------------

## Recomendaciones

<!-- -->
- Utilizar funciones de concurrencia para procesos, como las definidas en [`sysvipc(7)`][man-sysvipc] y [`sem_overview(7)`][man-sem_overview]
- Utilizar un semáforo o mutex para la concurrencia entre hilos
- Existe un [repositorio de código de ejemplo][codigo-ejemplo] que se puede utilizar para esta actividad
<!-- -->

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

--------------------------------------------------------------------------------

### Ejemplos de ejecución

La ejecución para mostrar la versión de los programas y el texto de ayuda es la misma que se ha manejado con anterioridad.

Se utiliza el cliente `curl` o un navegador web para comunicarse con el proceso del servidor web.

```text
$ curl -v#0 http://127.0.0.1:8080/
> GET / HTTP/1.0
> Host: 127.0.0.1:8000
> Connection: close
>
< HTTP/1.0 200 OK
< Server: httpd/0.0.1 (procs)
< Date: Sun, 12 Dec 2021 03:04:05
< Content-type: text/plain; charset=UTF-8

Hola mundo
```

--------------------------------------------------------------------------------

[flujo-de-trabajo]: https://sistemasoperativos-ciencias-unam.gitlab.io/2022-1/tareas-so/workflow/
[repo-tareas]: https://gitlab.com/SistemasOperativos-Ciencias-UNAM/2022-1/tareas-so.git
[codigo-ejemplo]: https://gitlab.com/SistemasOperativos-Ciencias-UNAM/codigo-ejemplo.git
[ejemplo-openssl]: https://gitlab.com/SistemasOperativos-Ciencias-UNAM/codigo-ejemplo/-/tree/master/openssl
[hashdeep-sourceforge]: http://md5deep.sourceforge.net/start-hashdeep.html
[man-sysvipc]: https://man7.org/linux/man-pages/man7/svipc.7.html
[man-sem_overview]: https://man7.org/linux/man-pages/man7/sem_overview.7.html
[archivos-muestra]: https://gitlab.com/SistemasOperativos-Ciencias-UNAM/sistemasoperativos-ciencias-unam.gitlab.io/-/blob/master/docs/laboratorio/practica-4/files/

[logformat-common]: https://httpd.apache.org/docs/2.4/logs.html#common
[logformat-common-wikipedia]: https://en.wikipedia.org/wiki/Common_Log_Format

[mime-types]: https://mimetype.io/all-types/

[man-asctime]: https://linux.die.net/man/3/asctime
[man-ctime]: https://linux.die.net/man/3/ctime
[man-datetime]: https://linux.die.net/man/3/datetime
[man-ftime]: https://linux.die.net/man/3/ftime
[man-gettime]: https://linux.die.net/man/3/gettime
[man-localtime]: https://linux.die.net/man/3/localtime
[man-mktime]: https://linux.die.net/man/3/mktime
[man-strftime]: https://linux.die.net/man/3/strftime

[rfc-822]: https://www.w3.org/Protocols/rfc822/
[rfc-822-problems]: https://validator.w3.org/feed/docs/warning/ProblematicalRFC822Date.html
[rfc-7231]: https://tools.ietf.org/html/rfc7231#section-7.1.1.1
