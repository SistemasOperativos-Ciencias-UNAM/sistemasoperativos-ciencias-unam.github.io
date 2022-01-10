---
# https://www.mkdocs.org/user-guide/writing-your-docs/#meta-data
title: Examenes
authors:
- Andrés Leonardo Hernández Bermúdez
---
# Tercer examen parcial

La evaluación correspondiente al tercer parcial se llevará a cabo a través de un proyecto.

- Este proyecto corresponde únicamente a la evaluación del tercer parcial
- Esta actividad no representa un proyecto final del curso y no sustituye a ninguno de los trabajos solicitados con anterioridad
- Esta evaluación no se puede considerar como el único elemento para calificar el curso

-------------------------------------------------------------------------------

## Restricciones

- La fecha de entrega es el día **domingo 23 de enero de 2022** a las 23:59 hrs
- Esta actividad debe ser entregada **por equipo** de acuerdo al [flujo de trabajo para la entrega de tareas y prácticas][flujo-de-trabajo]
    - Crear un _merge request_ en el [repositorio de tareas][repo-tareas] para entregar la actividad
    - Se considerarán los mismos equipos de trabajo registrados para los trabajos anteriores del semestre.

-------------------------------------------------------------------------------

## Temas

Se asignará un tema y actividad a cada equipo de trabajo, **la asignación no es negociable**

**A**: Creación de una práctica con código base de ejemplo y código de solución tomando en cuenta alguno de los siguientes temas (se asignará uno por equipo):

- [SHM: Memoria compartida][man-shm]
- Manejo de memoria con [mmap][man-mmap] / [munmap][man-munmap]
- [MP: Paso de mensajes][man-sysvipc]
- [MQ: Colas de mensajes][man-mq]

**B**: Creación de una práctica guiada para elaborar aplicaciones auto-contenidas para GNU/Linux utilizando alguno de los siguientes mecanismos (se asignará uno por equipo):

- [SnapCraft][docs-snapcraft]
- [FlatPak][docs-flatpak]
- [AppImage][docs-appimage]

-------------------------------------------------------------------------------

## Descripción de los proyectos

El código de los programas debe estar comentado línea por línea, explicando la funcionalidad implementada en el código.

También se debe entregar un documento en formato Markdown donde se explique la teoría detrás del concepto que se encargó, incluyendo diagramas de cómo funciona el programa y el ejemplo de su ejecución.

### Comunicación entre procesos

Para el tema asignado, elaborar los siguientes elementos:

Programa que muestre la funcionalidad básica del mecanismo de comunicación entre procesos, de la misma manera en la que se tienen los demás ejemplos del curso:

- [Archivo compartido][ipc-archivo]
- [PIPE][ipc-pipe]
- [FIFO][ipc-fifo]
- [Sockets UNIX][ipc-socket-unix]
- [Sockets TCP][ipc-socket-tcp]
- [Sockets UDP][ipc-socket-udp]

Elaborar una extensión al código de alguna de las prácticas anteriores para implementar la funcionalidad deseada, de acuerdo al tema asignado:

#### SHM: Memoria compartida

Hashdeep con memoria compartida

- 1 bloque con el contenido del archivo
- 4 bloques con la respuesta (md5, sha1, sha256, sha512)
- Requiere sincronización

#### Manejo de memoria con mmap

Utilizar mmap para leer en las peticiones GET y para escribir en las peticiones PUT

Petición:

```
PUT /ARCHIVO HTTP/1.1
Host: localhost
Content-Type: application/octet-stream
Content-Length: 12345
Connection: close

DATOS BINARIOS DEL ARCHIVO
```

Respuesta

```
HTTP/1.1 201 Created
Content-Location: /ARCHIVO
```

Crear la ruta hacia ARCHIVO en caso de que no exista

#### MP: Paso de mensajes

Extensión del servidor web que junte todas las bitácoras y las envíe a SYSLOG

- Requiere sincronización

#### MQ: Colas de mensajes
Extensión del servidor web que junte todas las bitácoras y las envíe a SYSLOG

- Requiere sincronización

### Aplicaciones auto-contenidas

Hacer una práctica guiada que contemple el uso de las herramientas para hacer que la aplicación git, compilada desde fuente, sea autocontenida y que tenga todas las dependencias.

- Archivos de [solución de la práctica 1][practica_1-solucion], donde viene el _Makefile_ y el _script de pruebas_ utilizados para la aplicación `git`
- Prefix: `/usr/local`
- Dependencias de `git`: `openssl`, `libpcre`, `curl`, `expat`, `iconv`, `zlib`
- No incluir la dependencia de `tcl/tk` porque el programa no incluirá soporte gráfico

La práctica guiada debe contener toda la documentación asociada a los requerimientos, conocimientos previos, desarrollo, instrucciones paso a paso, archivos base, archivos terminados y una liga al recurso terminado y empaquetado.

- [SnapCraft][docs-snapcraft]
- [FlatPak][docs-flatpak]
- [AppImage][docs-appimage]

-------------------------------------------------------------------------------

## Entregables

### Comunicación entre procesos

- Documentación en el archivo README.md
    - Especificación de la práctica
- Código fuente de la aplicación simple que demuestre la funcionalidad del mecanismo asignado
- Código fuente de la aplicación base para la práctica
- Código fuente de la solución a la práctica
- Cualquier archivo de prueba o archivo extra requerido para la práctica
- Binarios estáticamente ligados de todos los programas entregados

### Aplicaciones autocontenidas

- Documentación en el archivo README.md
- Especificación de la práctica en el archivo practica.md
- Solución de la práctica en el archivo solucion.md
- Lista detallada de pasos a seguir para compilar, empaquetar y ejecutar la aplicación autocontenida en un sistema operativo Debian 11
- Utilizar ligado dinámico para los binarios de git

-------------------------------------------------------------------------------

[flujo-de-trabajo]: https://sistemasoperativos-ciencias-unam.gitlab.io/2022-1/tareas-so/workflow/
[repo-tareas]: https://gitlab.com/SistemasOperativos-Ciencias-UNAM/2022-1/tareas-so.git

[practica_1-solucion]: https://gitlab.com/SistemasOperativos-Ciencias-UNAM/2022-1/tareas-so/-/tree/entregados/docs/entrega/practica-1/solucion

[man-shm]: https://linux.die.net/man/7/shm_overview
[man-mmap]: https://linux.die.net/man/3/mmap
[man-munmap]: https://linux.die.net/man/3/munmap
[man-sysvipc]: https://linux.die.net/man/7/svipc
[man-ipc]: https://linux.die.net/man/2/ipc
[man-mq]: https://linux.die.net/man/7/mq_overview

[docs-snapcraft]: https://snapcraft.io/docs
[docs-flatpak]: https://docs.flatpak.org/
[docs-appimage]: https://docs.appimage.org/
[docs-bottles]: https://docs.usebottles.com/

[ipc-archivo]: https://gitlab.com/SistemasOperativos-Ciencias-UNAM/codigo-ejemplo/-/blob/master/process/dup/dup-2-file.c
[ipc-pipe]: https://gitlab.com/SistemasOperativos-Ciencias-UNAM/codigo-ejemplo/-/blob/master/process/dup/dup-3-pipe.c
[ipc-fifo]: https://gitlab.com/SistemasOperativos-Ciencias-UNAM/codigo-ejemplo/-/blob/master/process/dup/dup-4-fifo.c
[ipc-socket-unix]: https://gitlab.com/SistemasOperativos-Ciencias-UNAM/codigo-ejemplo/-/blob/master/process/socket/bind-1-unix.c
[ipc-socket-tcp]: https://gitlab.com/SistemasOperativos-Ciencias-UNAM/codigo-ejemplo/-/blob/master/process/socket/bind-2-tcp.c
[ipc-socket-udp]: https://gitlab.com/SistemasOperativos-Ciencias-UNAM/codigo-ejemplo/-/blob/master/process/socket/bind-3-udp.c
