# Arquitectura y componentes de una computadora

* Revisar la [guía rápida de `git`](../git.md "man 1 git") para recordar como se mandan los cambios a un repositorio.

## Objetivo

Obtener un inventario de los componentes que tiene un equipo de cómputo y la manera en la que se interconectan dentro de un equipo físico

## Restricciones

Esta tarea debe ser entregada **individualmente**

## Requisitos

+ Equipo **físico** ejecutando alguna distribución de GNU/Linux
+ LiveDVD o LiveUSB de [Debian][debian-live] o [Ubuntu][ubuntu-live]
+ Tener los siguientes programas instalados:

  - `git`
  - `lspci`
  - `lsusb`
  - `lshw`

## Actividades

### Iniciar con LiveDVD o LiveUSB

+ Iniciar la PC con un LiveCD o LiveUSB de [Debian][debian-live] o [Ubuntu][ubuntu-live]

  - Grabar [Debian][debian-live] o [Ubuntu][ubuntu-live] en un DVD o utilizar [UNetbootin][unetbootin] o [Startup disk creator][ubuntu-live-info] para crear el **LiveUSB**

>>>
**Advertencia**

+ Todos los archivos que se generen mientras se utiliza el LiveUSB o LiveDVD se almacenan en memoria RAM y no son persistentes (no se guardan en disco) por lo que se perderán si se reinicia el equipo
+ Copiar todos los archivos a otra unidad USB para referencia futura y además enviarlos al repositorio de GitLab
>>>

### Actualizar lista de repositorios e instalar paquetes

+ Abrir una terminal y ejecutar `sudo apt update` para actualizar la lista de paquetes disponibles
+ Instalar los programas mencionados en la sección de requisitos

  - Se puede buscar el paquete al que corresponde algún programa en la [lista de Debian][debian-packages] o en la [lista de Ubuntu][ubuntu-packages]

### Crear repositorio en GitLab

+ Crear un repositorio en la cuenta de usuario de GitLab y clonarlo en el equipo local con `git clone`

  - Revisar la [guía rápida de `git`][guia-git]
  - Configurar adecuadamente las variables `user.name` y `user.email` con `git config`
>>>
Nota: Los paquetes se pueden agregar a una instalación ya existente
>>>

#### Escribir `README.md` y anexar salida de comandos

+ Anotar el **nombre** del autor y la liga de la descripción de esta tarea en el archivo `README.md`

+ Escribir en el archivo `README.md` un resumen de los componentes que tiene el equipo (CPU, memoria RAM, disco duro, tarjetas de red y dispositivos)

+ Adjuntar las secciones relevantes de la salida de programas y archivos mencionados y además anexar los archivos completos dentro del directorio `output`

+ Leer la _página de man_ de cada comando y anotar porque se especificaron las opciones de línea de comandos y de que manera afectan a la salida del programa

### Subir resultados al repositorio de GitLab

+ Revisar la [guía rápida de `git`][guia-git]
+ Agregar el archivo `README.md` y los demás archivos al repositorio con `git add`
+ Guardar cambios con `git commit`
+ Subir al repositorio con `git push -u origin master`

### Listar el tipo de procesador y memoria

+ `/proc/cpuinfo`
+ `/proc/meminfo`

### Listar los dispositivos conectados al bus PCI

+ `# lspci`
+ `# lspci -v -t`
+ `# lspci -vv`

### Listar los dispositivos conectados al bus USB

+ `# lsusb`
+ `# lsusb -t`
+ `# lsusb -v`

### Listar otros elementos del sistema operativo

+ `/proc/interrupts`
+ `/proc/modules`
+ `/proc/misc`
+ `/proc/mounts`
+ `/proc/partitions`
+ `/proc/schedstat`
+ `/proc/swaps`
+ `/proc/vmstat`

### Obtener la lista completa de hardware del equipo

+ `# lshw`
+ `# lshw -html`
+ `# lshw -short`
+ `# lshw -businfo`

## Extra

### Información sobre el disco duro

+ Instalar el paquete `smartmontools` y obtener la salida de los siguientes comandos:

+ `# smartctl --scan`
+ `# smartctl --all /dev/sda`
+ `# smartctl --xall /dev/sda`

[guia-git]: ../git.md "Guía rápida de git"
[unetbootin]: https://unetbootin.github.io/ "UNetbootin: LiveUSB creator"
[debian-live-info]: https://www.debian.org/CD/live/ "Debian LiveDVD"
[ubuntu-live-info]: https://tutorials.ubuntu.com/tutorial/try-ubuntu-before-you-install "Ubuntu LiveUSB"
[debian-live]: https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/ "Debian 9 stretch live"
[ubuntu-live]: http://releases.ubuntu.com/bionic/ "Ubuntu 18.04 LTS bionic beaver"
[debian-packages]: https://packages.ubuntu.com/ "Lista de paquetes de Debian"
[ubuntu-packages]: https://packages.ubuntu.com/ "Lista de paquetes de Ubuntu"
