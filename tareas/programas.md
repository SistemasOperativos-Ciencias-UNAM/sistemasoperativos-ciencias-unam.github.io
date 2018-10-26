# Programas de sistema de archivos, procesos, hilos y señales

## Objetivo

Implementar de manera independiente los componentes de un demonio estándar de red UNIX

## Restricciones

Esta tarea debe ser entregada **individualmente**

## Requisitos

+ Compilador `cc`
+ Cabeceras estándar de GNU/Linux

## Lista de programas

| puntos | nombre		|
|:------:|:--------------------:|
|	 | `ps_pthread_props`	|
|	 | `signals`		|
|	 | `pthread_signals`	|
|	 | `proc_pthread`	|
|	 | `hashdeep`		|
|	 | `reader`		|
|	 | `octal-mode`		|
|	 | `shell`		|
|	 | `terminator`		|
|	 | `lsof`		|
|	 | `ps`			|
|	 | `logger`		|
|	 | `rainbow`		|
|	 | `logrotate`		|
|	 | `su`			|
|	 | `rinetd`		|
|	 | `nmap`		|
|	 | `memcached`		|
|	 | `nsca_httpd`		|
|	 | `backdoor`		|

## Descripción

### `ps_pthread_props`

* Imprime todas las propiedades de un proceso y de todos sus hilos
* Revisar las estructuras que se generan en `/proc/<pid>` y `/proc/<pid>/task/<tid>`
  - No se deben leer estos archivos, sino que se debe obtener esta información mediante llamadas al sistema
	* Averiguar cómo se pueden obtener las métricas y estadísticas que generan `top(1)` y `htop(1)`

+ <https://linux.die.net/man/7/credentials>
+ <https://linux.die.net/man/7/pthreads>
+ <https://linux.die.net/man/5/proc>
+ <https://linux.die.net/man/1/top>
+ <https://linux.die.net/man/1/htop>

### `signals`

* Asigna un manejador con `signal(2)` para **TERM** y otro diferente con `sigaction(2)` para las otras señales
* Lanza N procesos hijo y envía una señal diferente a cada uno

+ <https://linux.die.net/man/7/signal>
+ <https://linux.die.net/man/2/signal>
+ <https://linux.die.net/man/2/sigaction>
+ <https://linux.die.net/man/3/kill>

### `pthread_signals`

* Crea N hilos y asigna un manejador para cada señal
* Utiliza `pthread_sigmask` para establecer el manejador y atender la señal que recibe cada hilo

+ <https://linux.die.net/man/7/signal>
+ <https://linux.die.net/man/3/pthread_sigmask>
+ <https://linux.die.net/man/2/sigprocmask>
+ <https://linux.die.net/man/3/kill>
+ <https://linux.die.net/man/3/pthread_kill>

### `proc_pthread`

Programa que lanza subprocesos con hilos y modifica la ejecución de acuerdo a la señal que reciba:

* Al recibir **USR1** crea un subproceso adicional
* Al recibir **HUP** mata uno de los subprocesos
* Al recibir **USR2** cada subproceso crea un hilo más
* Al recibir **INT** cada proceso finaliza uno de sus hilos
* Al recibir **TERM** mata primero todos los hilos y después todos los subprocesos

+ <https://linux.die.net/man/2/fork>
+ <https://linux.die.net/man/7/pthreads>
+ <https://linux.die.net/man/3/kill>
+ <https://linux.die.net/man/3/pthread_kill>

### `hashdeep`

* Calcula la _suma de verificación_ **md5** y **sha1** de un archivo utilizando procesos o hilos diferentes
* La lista de archivos se puede pasar por **STDIN** (un archivo por línea) o como argumentos al programa
* Realizar cada _suma de verificación_ en un hilo separado
* Al terminar de procesar el archivo imprimir el resultado en **STDOUT** con el siguiente formato separado por `\t`

```
nombre	tamaño	md5	sha1
```

+ <https://linux.die.net/man/1/hashdeep>
+ <https://linux.die.net/man/3/md5_init>
+ <https://linux.die.net/man/3/sha>
+ <https://www.gnu.org/software/parallel/>
+ <https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/crypto/md5.c>
+ <https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/crypto/sha1_generic.c>

### `reader`

* Lee los archivos de entrada especificados por los argumentos uno en cada subproceso o hilo
* Muestra al final cuantas veces aparece cada vocal en cada archivo y cuántos caracteres fueron leídos por todos los subprocesos e hilos en total

```
archivo	a	e	i	o	u
total
```

+ <https://linux.die.net/man/1/wc>
+ <https://www.gnu.org/software/parallel/>

### `octal-mode`

* Crea todas las posibilidades de permisos en **archivos** y **directorios**, desde `000` hasta `777`
* Para los **archivos** comprueba que se puedan _abrir_, _leer_, _modificar_ y _borrar_
* Para los **directorios** comprueba que se pueda _cambiar al directorio_, _listar el contenido_, _crear_ y _borrar_ archivos

+ <https://linux.die.net/man/3/chdir>
+ <https://linux.die.net/man/3/chmod>
+ <https://linux.die.net/man/3/chown>
+ <https://linux.die.net/man/3/stat>
+ <https://linux.die.net/man/3/mkdir>
+ <https://linux.die.net/man/3/rmdir>
+ <https://linux.die.net/man/3/unlink>
+ <https://linux.die.net/man/3/truncate>
+ <https://linux.die.net/man/3/fopen>
+ <https://linux.die.net/man/2/open>
+ <https://en.wikipedia.org/wiki/File_system_permissions#Notation_of_traditional_Unix_permissions>
+ <http://permissions-calculator.org/>
+ <https://www.tutorialspoint.com/unix/unix-file-permission.htm>

### `shell`

Lee los comandos desde la entrada estándar y los ejecuta conectando la salida estándar y el error estándar a cada proceso hijo

+ <https://git.busybox.net/busybox/tree/shell>
+ <https://linux.die.net/man/2/fork>
+ <https://linux.die.net/man/3/exec>
+ <https://linux.die.net/man/3/system>

### `terminator`

* Envía una señal a todos los procesos del sistema, excepto a si mismo
* Implementa manejo de errores y avisa cuando no pudo enviar una señal y explica por qué no se pudo

+ <https://linux.die.net/man/3/kill>
+ <https://linux.die.net/man/3/errno>
+ <https://linux.die.net/man/3/explain>
+ <https://linux.die.net/man/3/explain_kill>

### `lsof`

* Lista todos los archivos abiertos de todos los programas del sistema
* Específica el tipo de archivo y el proceso e hilo que lo tiene abierto, así como el modo en el que se abrió
* Este programa necesita ejecutarse como `root`

+ <https://linux.die.net/man/8/lsof>
+ <https://git.busybox.net/busybox/tree/procps/lsof.c>

### `ps`

* Lista la información de todos los procesos del sistema
* Este programa necesita ejecutarse como `root`

+ <https://git.busybox.net/busybox/tree/procps/ps.c>

### `logger`

Demonio que recibe un mensaje desde un socket UNIX y lo imprime a syslog

+ <https://linux.die.net/man/3/syslog>

### `rainbow`

* Demonio que recibe una cadena desde **STDIN** y la guarda en memoria junto con su _hash_ **md5** y **sha1**
* Al recibir **HUP** imprime el contenido de la memoria en **STDOUT**
* Al recibir **INT** guarda el contenido de la memoria en un archivo separado por `\t`
* Al iniciar carga el contenido de este archivo en memoria si es que existe

+ <https://en.m.wikipedia.org/wiki/Rainbow_table>

### `logrotate`

* Lee desde un `fifo` y guarda en memoria el contenido
* Escribe en un archivo cuando recibe la señal **USR1**
* _Rota_ el archivo al recibir la señal **HUP**

+ <https://linux.die.net/man/8/logrotate>

### `su`

* Cambia privilegios a otro usuario y ejecuta un comando con los privilegios del nuevo usuario
* El comando puede ser especificado como argumento a este programa
* Ejecuta el comando especificado por la _variable de entorno_ `SHELL` si no se pasaron argumentos

+ <https://git.busybox.net/busybox/tree/loginutils/su.c>
+ <https://linux.die.net/man/2/fork>
+ <https://linux.die.net/man/3/exec>

### `rinetd`

* Escucha conexiones **TCP** en `bindaddress`:`bindport`
* Cada conexión que recibe es redireccionada a `connectaddress`:`connectport`
* Lee su configuración desde un archivo separado por `\t`

```
bindadress	bindport	connectaddress	connectport
```

+ <https://manpages.debian.org/stretch/rinetd/rinetd.8.en.html>

### `nmap`

Crea N hilos y cada hilo verifica que se pueda conectar a un puerto TCP del host de destino. Al final muestra un resumen de los puertos que incluye el nombre y número de puerto

+ <https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers#Well-known_ports>
+ <https://linux.die.net/man/3/getservent>

### `memcached`

Implementa el protocolo MemCache con los comandos "set", "get", "delete", "flush" y "stats". Soporta un cliente por socket UNIX

+ <https://github.com/memcached/memcached>
+ <https://github.com/memcached/memcached/blob/master/doc/protocol.txt>
+ <https://github.com/memcached/memcached/blob/master/doc/threads.txt>

### `nsca_httpd`

Servidor web que implementa el método GET y los códigos de estado 200, 403, 404 y 500. El directorio raíz del servidor es pasado como primer argumento al programa, imprime la bitácora de acceso a STDOUT y la bitácora de errores a STDERR. Atiende a los clientes con hilos

+ <https://en.wikipedia.org/wiki/List_of_HTTP_status_codes>
+ <https://en.wikipedia.org/wiki/List_of_HTTP_header_fields>
+ <https://en.wikipedia.org/wiki/Common_Log_Format>
+ <https://httpd.apache.org/docs/2.4/logs.html> |

### `backdoor`

* El programa **servidor** escucha conexiones por TCP y socket UNIX
* Conecta internamente el socket del primer cliente TCP con el primer cliente UNIX
* Las conexiones pueden ser atendidas por procesos o hilos

* El programa **local** se conecta al servidor via socket UNIX
* Este programa _envía_ comandos al programa **remoto**
* Conecta **STDIN** a la parte del socket que envía
* Conecta **STDOUT** y **STDERR** a la parte del socket que recibe

* El programa **remoto** se conecta al servidor via TCP
* Este programa _recibe_ comandos desde el programa **local**
* Conecta **STDIN** a la parte del socket que recibe
* Conecta **STDOUT** y **STDERR** a la parte del socket que envía
* Al establecer una conexión ejecuta el programa especificado por la _variable de entorno_ `SHELL`

+ <https://linux.die.net/man/3/socket>
+ <https://linux.die.net/man/3/bind>
+ <https://linux.die.net/man/3/listen>
+ <https://linux.die.net/man/3/accept>
