# Programas de sistema de archivos, procesos, hilos y señales

## Objetivo

Implementar de manera independiente los componentes de un demonio estándar de red UNIX

## Restricciones

Esta tarea debe ser entregada **individualmente**

## Requisitos

+ Compilador `cc`
+ Cabeceras estándar de GNU/Linux

## Lista de programas

| Nombre             | Descripción |
|:------------------:|:------------|
| `ps_pthread_props` | Imprime todas las propiedades de un proceso y de todos sus hilos <br/> <https://linux.die.net/man/7/credentials> <br/> <https://linux.die.net/man/7/pthreads> |
| `signals`          | Asigna un manejador con signal para TERM y otro diferente con sigaction para las otras señales, lanza N procesos hijo y envía una señal diferente a cada uno <br/> <https://linux.die.net/man/7/signal> <br/> <https://linux.die.net/man/2/signal> <br/> <https://linux.die.net/man/2/sigaction> <br/> <https://linux.die.net/man/3/kill> |
| `pthread_signals`  | Crea N hilos y asigna un manejador para cada señal. Utiliza `pthread_sigmask` para establecer el manejador y atender la señal que recibe cada hilo <br/> <https://linux.die.net/man/7/signal> <br/> <https://linux.die.net/man/3/pthread_sigmask> <br/> <https://linux.die.net/man/2/sigprocmask> <br/> <https://linux.die.net/man/3/kill> <br/> <https://linux.die.net/man/3/pthread_kill> |
| `proc_pthread`     | Programa que lanza subprocesos con hilos, al recibir USR1 crea un subproceso adicional, al recibir HUP mata uno de los subprocesos, al recibir USR2 cada subproceso crea un hilo más, al recibir INT cada proceso finaliza uno de sus hilos. al recibir TERM mata primero todos los hilos y después todos los subprocesos <br/> <https://linux.die.net/man/2/fork> <br/> <https://linux.die.net/man/7/pthreads> <br/> <https://linux.die.net/man/3/kill> <br/> <https://linux.die.net/man/3/pthread_kill> |
| `hashdeep`         | Calcula la suma de verificación md5 y sha1 de un archivo utilizando procesos o hilos diferentes <br/> <https://linux.die.net/man/1/hashdeep> <br/> <https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/crypto/md5.c> <br/> <https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/crypto/sha1_generic.c> <br/> <https://linux.die.net/man/3/md5_init> <br/> <https://linux.die.net/man/3/sha> <br/> <https://www.gnu.org/software/parallel/> |
| `reader`           | Lee los archivos de entrada especificados por los argumentos uno en cada subproceso o hilo, muestra al final cuantas veces aparece cada vocal en cada archivo y cuántos caracteres fueron leídos por todos los subprocesos e hilos en total <br/> <https://linux.die.net/man/1/wc> <br/> <https://www.gnu.org/software/parallel/> |
| `octal-mode`       | Crea todas las posibilidades de permisos en archivos y directorios, desde 000 hasta 777. para los archivos comprueba que se puedan abrir, leer, modificar y borrar. para los directorios comprueba que se pueda cambiar, listar el contenido, crear archivos y borrarlos <br/> <https://linux.die.net/man/3/chdir> <br/> <https://linux.die.net/man/3/chmod> <br/> <https://linux.die.net/man/3/chown> <br/> <https://linux.die.net/man/3/stat> <br/> <https://linux.die.net/man/3/mkdir> <br/> <https://linux.die.net/man/3/rmdir> <br/> <https://linux.die.net/man/3/unlink> <br/> <https://linux.die.net/man/3/truncate> <br/> <https://linux.die.net/man/3/fopen> <br/> <https://linux.die.net/man/2/open> |
| `shell`            | Lee los comandos desde la entrada estándar y los ejecuta conectando la salida estándar y el error estándar a cada proceso hijo <br/> <https://git.busybox.net/busybox/tree/shell> <br/> <https://linux.die.net/man/2/fork> <br/> <https://linux.die.net/man/3/exec> <br/> <https://linux.die.net/man/3/system> |
| `terminator`       | Envía una señal a todos los procesos, excepto a si mismo. implementa manejo de errores y avisa cuando no pudo enviar una señal y explica por qué no se pudo <br/> <https://linux.die.net/man/3/kill> <br/> <https://linux.die.net/man/3/explain_kill> |
| `lsof`             | Lista todos los archivos abiertos, específica el tipo de archivo y el proceso e hilo que lo tiene abierto, así como el modo en el que se abrió <br/> <https://git.busybox.net/busybox/tree/procps/lsof.c> |
| `ps`               | Lista la información de todos los procesos del SO <br/> <https://git.busybox.net/busybox/tree/procps/ps.c> |
| `logger`           | Demonio que recibe un mensaje desde un socket UNIX y lo imprime a syslog <br/> <https://linux.die.net/man/3/syslog> |
| `rainbow`          | Demonio que recibe una cadena desde STDIN y la guarda en memoria junto con su hash MD5 y SHA1. Al recibir HUP imprime el contenido de la memoria en STDOUT. Al recibir INT guarda el contenido de la memoria en un archivo separado por \t y al iniciar carga el contenido de este archivo en memoria <br/> <https://en.m.wikipedia.org/wiki/Rainbow_table> |
| `logrotate`        | Lee desde un fifo y guarda en memoria el contenido. escribe en un archivo cuando recibe la señal USR1 y rota el archivo al recibir la señal HUP <br/> <https://linux.die.net/man/8/logrotate> |
| `su`               | Cambia privilegios a otro usuario y ejecuta un comando con los privilegios del nuevo usuario. El comando puede ser especificado como argumento a este programa o ejecuta /bin/bash si no se pasaron argumentos <br/> <https://git.busybox.net/busybox/tree/loginutils/su.c> <br/> <https://linux.die.net/man/2/fork> <br/> <https://linux.die.net/man/3/exec> |
| `listener`         | Demonio que escucha en un socket UNIX y en un puerto de red, las conexiones al socket son atendidas por procesos y las del puerto de red con hilos <br/> <https://linux.die.net/man/3/socket> <br/> <https://linux.die.net/man/3/bind> <br/> <https://linux.die.net/man/3/listen> <br/> <https://linux.die.net/man/3/accept> |
| `dropper`          | Copia un programa a /tmp, hace exec y borra el ejecutable mientras está corriendo como demonio |  |
| `memcached`        | Implementa el protocolo MemCache con los comandos "set", "get", "delete", "flush" y "stats". Soporta un cliente por socket UNIX <br/> <https://github.com/memcached/memcached> <br/> <https://github.com/memcached/memcached/blob/master/doc/protocol.txt> <br/> <https://github.com/memcached/memcached/blob/master/doc/threads.txt> |
| `nmap`             | Crea N hilos y cada hilo verifica que se pueda conectar a un puerto TCP del host de destino. Al final muestra un resumen de los puertos que incluye el nombre y número de puerto <br/> <https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers#Well-known_ports> <br/> <https://linux.die.net/man/3/getservent> |
| `nsca_httpd`       | Servidor web que implementa el método GET y los códigos de estado 200, 403, 404 y 500. El directorio raíz del servidor es pasado como primer argumento al programa, imprime la bitácora de acceso a STDOUT y la bitácora de errores a STDERR. Atiende a los clientes con hilos <br/>  <https://en.wikipedia.org/wiki/List_of_HTTP_status_codes> <br/> <https://en.wikipedia.org/wiki/List_of_HTTP_header_fields> <br/> <https://en.wikipedia.org/wiki/Common_Log_Format> <br/> <https://httpd.apache.org/docs/2.4/logs.html> |
