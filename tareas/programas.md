# Programas de sistema de archivos, procesos, hilos y señales

## Objetivo

- Implementar de manera independiente los componentes de un demonio estándar de red UNIX

## Requisitos

- Compilador `cc`
- Cabeceras estándar de GNU/Linux

## Lineamientos

- Juntar 10 puntos como mínimo
- Hay una [tabla](#lista-de-programas) con los puntajes asociados a cada programa
- La tarea se califica _sobre 10_, se anotarán los puntos que junten de acuerdo a los programas que realicen
- Hay algunos programas que se pueden implementar con procesos o con hilos, pueden hacer las dos versiones y obtener los puntos correspondientes a cada una

## Restricciones

- Fecha de entrega **Lunes 18 de enero de 2021**
- Se debe redactar la documentación en el archivo `README.md`, incluir el nombre y número de cuenta de los autores
- La implementación de los programas debe ser en lenguaje C
- El repositorio debe incluir un archivo `Makefile` que compile y realice las pruebas de cada programa
- Para las pruebas se debe escribir un _script_ que ejecute el programa con las opciones y archivos de datos necesarios para realizar las pruebas
- Anotar al inicio del código fuente de los programas y demás archivos el nombre y número de cuenta de los autores:
```
/*
prog - Programa que implementa X

123456789 - Andrés Hernández
098765432 - Jose Luis Torres
*/
```

## Entrega

- La entrega de los programas es de manera **individual** o en **parejas**
  - Dar los permisos adecuados al repositorio _fork_ para que el otro integrante pueda hacer _push_ de sus cambios
- Enviar el código fuente sin binarios ejecutables mediante _merge request_ al [repositorio de tareas](https://gitlab.com/SistemasOperativos-Ciencias-UNAM/2021-1/tareas-so.git)
  - Asignar a @tonejito y @umoqnier como revisores del _merge request_
- Crear una rama llamada `Programas-AAAA-BBBB` (donde `AAAA` y `BBBB` son las iniciales de los integrantes)
- El código se entrega en la carpeta de uno de los integrantes y se debe hacer una líga simbólica en el repositorio para indicar que estan entregando los programas
  - Detalles de esto mas adelante, pueden dejar esto hasta el final
  - Ej. `content/entrega/AndresHernandez/tarea-programas`

## Lista de programas

| Puntos | Nombre				| Procesos	| Hilos	|
|:------:|:------------------------------------:|:-------------:|:-----:|
| 1 	 | [`reader`](#reader)			| ✔		| ✔	|
| 2 	 | [`ps_pthread_props`](#ps_pthread_props)	| ⭕		| 	|
| 2	 | [`proc_pthread`](#proc_pthread)	| ⭕		| ⭕	|
| 2	 | [`logger`](#logger)			| ✔		| ✔	|
| 4	 | [`syslog`](#syslog)			| ✔		| ✔	|
| 3	 | [`signals`](#signals)		| ✔		| 	|
| 3 	 | [`lsof`](#lsof)			| ⭕		| 	|
| 4	 | [`ps`](#ps)				| ⭕		| 	|
| 4	 | [`nuke`](#nuke)			| ⭕		| 	|
| 4	 | [`octal-mode`](#octal-mode)		| ⭕		| 	|
| 4	 | [`shell`](#shell)			| ⭕		| 	|
| 4	 | [`hashdeep`](#hashdeep)		| ✔		| ✔	|
| 4	 | [`rainbow`](#rainbow)		| ✔		| ✔	|
| 6	 | [`rinetd`](#rinetd)			| ✔		| ✔	|
| 6	 | [`nmap`](#nmap)			| ✔		| ✔	|
| 8	 | [`memcached`](#memcached)		| ✔		| ✔	|
| 8	 | [`nsca_httpd`](#nsca_httpd)		| ✔		| ✔	|
| 10	 | [`backdoor`](#backdoor)		| ✔		| ✔	|

--------------------------------------------------------------------------------

## Descripción de los programas

### `reader`

* Lee los archivos de entrada especificados por los argumentos uno en cada subproceso o hilo
 - Lee desde `STDIN` si no se especifica un archivo de entrada
* Muestra al final cuantas veces aparece cada vocal en cada archivo y cuántos caracteres fueron leídos por todos los subprocesos e hilos en total
 - Debe tomar en cuenta las vocales _mayúsculas_ y _minúsculas_ con y sin _acentos_ y la letra U con _diéresis_:
 - `aeiou`, `AEIOU`, `áéíóú`, `ÁÉÍÓÚ`, `üÜ`
 - Considerar únicamente los caracteres de la tabla ASCII, donde cada uno es representado por exactamente 1 byte

##### Archivo de prueba

```
$ cat vocales.txt
AEIOU
aeiou
```

```
$ cat acentos.txt
ÁÉÍÓÚ
áéíóú
```

```
$ cat dieresis.txt
üÜ
```

##### Ejemplo

+ Leyendo desde `STDIN`:

```
$ ./reader < vocales.txt
vocal:	a	e	i	o	u
numero:	2	2	2	2	2
total:	10
```

+ Leyendo desde 3 archivos:

```
$ ./reader  vocales.txt  acentos.txt  dieresis.txt
vocal:	a	e	i	o	u
numero:	4	4	4	4	6
total:	22
```

+ <https://ascii-code.com/>
+ <https://ascii-code.net/>
+ <https://coding.tools/ascii-table>
+ <https://linux.die.net/man/1/wc>
+ <https://www.gnu.org/software/parallel/>

--------------------------------------------------------------------------------

### `ps_pthread_props`

* Imprime todas las propiedades de un **proceso** y de todos sus **hilos**
* Interpretar la información presente en `/proc/<pid>` y `/proc/<pid>/task/<tid>`
* Averiguar cómo se pueden obtener las métricas y estadísticas que generan `top(1)` y `htop(1)`

+ <https://linux.die.net/man/7/credentials>
+ <https://linux.die.net/man/7/pthreads>
+ <https://linux.die.net/man/5/proc>
+ <https://linux.die.net/man/1/top>
+ <https://linux.die.net/man/1/htop>
+ <https://gitlab.com/procps-ng/procps.git>
+ <https://github.com/htop-dev/htop.git>

--------------------------------------------------------------------------------

### `proc_pthread`

* Lanza subprocesos con hilos y modifica la ejecución de acuerdo a la señal que reciba:
* Imprime la información de cuantos procesos tiene y cuantos hilos tiene cada proceso
  - Imprimir el número de procesos hijos, así como su PID (_process id_)
  - Cada proceso hijo imprime el número de hilos y su TID (_task id_)
  - Al final imprime `--` para separar la salida de la siguiente ejecución
* Establecer una función de trabajo
* Funcionamiento esperado de acuerdo a la señal recibida:

| Señal     | Acción |
|:---------:|:------:|
| `SIGUSR1` | Crea un subproceso adicional |
| `SIGHUP`  | Mata uno de los subprocesos |
| `SIGUSR2` | Cada subproceso crea un hilo más |
| `SIGINT`  | Cada proceso finaliza uno de sus hilos |
| `SIGTERM` | Mata primero todos los hilos y después todos los subprocesos y finaliza el proceso padre |

--------------------------------------------------------------------------------

### `logger`

* Demonio que escucha en un socket UNIX y recibe mensajes de los clientes
  - Atiende a los clientes utilizando procesos o hilos
  - Escribe un mensaje en syslog con _facility_ `LOG_USER` y prioridad `LOG_INFO` al iniciar y terminar el programa

* Recibe de cada cliente mensajes en el siguiente formato y los escribe a syslog con el _facility_ y nivel indicados

```
<FACILITY>	<LEVEL>
<MENSAJE>
```

* Rechaza los mensajes que especifiquen algún _facility_ no soportado

| Campo      | Valores |
|:----------:|:-------:|
| _Facility_ | `LOG_LOCAL0` ... `LOG_LOCAL7` |
| Nivel      | `LOG_EMERG`, `LOG_ALERT`, `LOG_CRIT`, `LOG_ERR`, `LOG_WARNING`, `LOG_NOTICE`, `LOG_INFO` y `LOG_DEBUG` |

+ <https://linux.die.net/man/3/syslog>

--------------------------------------------------------------------------------

### `syslog`

* Demonio que escucha en el socket UNIX `/dev/log` y en el puerto `514` de TCP y UDP por **IPv4** e **IPv6**
* Atiende a los clientes utilizando procesos o hilos
* Implementar mecanismos de sincronización para evitar condiciones de carrera e interbloqueos
* Escucha los mensajes del protocolo syslog
  - Ignorar los campos de _prioridad_ y _facility_
* Establecer un _buffer circular_ en memoria de tamaño configurable en MB
* Escribir los mensajes de la bitácora en el _buffer circular_ y en el archivo de texto `/var/log/syslog` con el siguiente formato separado por `\t`:
```
fecha-hora	hostname	proceso [pid]	mensaje
```
  - **fecha-hora**: `YYYY-MM-DD HH:MM:SS`
  - **hostname**: formato corto, primer campo antes del punto (`hostname -s`)
  - **proceso** y **pid** que enviaron el mensaje de bitácora
  - **mensaje** de bitácora
* Al recibir alguna señal `HUP`, `INT` o `TERM` escribe el contenido del _buffer circular_ en el archivo `/tmp/syslog` y sale del programa

+ <https://tools.ietf.org/html/rfc5424>
+ <https://linux.die.net/man/8/syslogd>
+ <https://en.wikipedia.org/wiki/Syslog>
+ <https://www.paessler.com/it-explained/syslog>
+ <https://stackify.com/syslog-101/>
+ <https://www.dnsstuff.com/what-is-syslog>

--------------------------------------------------------------------------------

### `signals`

* Lanza N procesos hijo y envía una señal diferente a cada uno
  - Espera `1` segundo al enviar las señales a cada proceso hijo
  - Cuando el proceso padre reciba la señal `SIGHUP`, debe enviar la señal `SIGTERM` a **todos** los procesos hijo y crearlos de nuevo
  - Cuando el proceso padre reciba la señal `SIGINT`, debe enviar la señal `SIGTERM` a **todos** los procesos hijo y salir
  - Cuando el proceso padre termine de crear los procesos hijos, debe esperar `60` segundos antes de enviar la señal `SIGTERM` a **todos** los procesos hijo y salir

* Cada proceso hijo deberá entrar en un ciclo de espera largo utilizando `sleep(UINT_MAX)`

* Asignar a cada proceso hijo un manejador con `sigaction(2)` para las señales `1` a `15`
  - Explicar dentro del código utilizando comentarios si no es posible asignar un manejador a alguna señal
  - Este manejador asignado deberá imprimir todo el contexto de la señal utilizando la estructura `siginfo_t` y el manejador especificado por `sa_sigaction`
  - El contexto de la señal recibida deberá ser impreso a `STDERR`, debe incluir la fecha y hora actual
  - Adicionalmente se debe imprimir el contexto de la señal a las bitácoras del sistema utilizando `syslog(3)`
  - Después de manejar las señales `1` a `15` el programa debe salir exitosamente

* Asignar a cada proceso hijo un manejador con `signal(2)` para las señales comúnes entre Linux y macOS con identificador entre `16` y `31`
  - Ejecutar lo siguiente para ver las señales en común `$ paste signal/Linux.txt signal/macOS.txt`
  - Imprimir el número de la señal recibida, así como la fecha y hora actual a `STDERR` y a las bitácoras del sistema utilizando `syslog(3)`
  - Los manejadores de señales `16` a `31` no deben causar la salida del programa

+ <https://linux.die.net/man/7/signal>
+ <https://linux.die.net/man/2/signal>
+ <https://linux.die.net/man/2/sigaction>
+ <https://linux.die.net/man/3/kill>
+ <https://linux.die.net/man/3/sleep>
+ <https://linux.die.net/man/3/syslog>
+ [`signal/Linux.txt`](../temas/signal/Linux.txt)
+ [`signal/macOS.txt`](../temas/signal/macOS.txt)

--------------------------------------------------------------------------------

### `lsof`

* Lista todos los archivos abiertos de todos los programas del sistema
* Específica el tipo de archivo y el proceso e hilo que lo tiene abierto, así como el modo en el que se abrió
* Este programa necesita ejecutarse como `root`

+ <https://linux.die.net/man/8/lsof>
+ <https://git.busybox.net/busybox/tree/procps/lsof.c>

--------------------------------------------------------------------------------

### `ps`

* Lista la información de todos los procesos del sistema
* Inspeccionar el contenido de `/proc/<pid>`
* Este programa necesita ejecutarse como `root`

+ <https://git.busybox.net/busybox/tree/procps/ps.c>

--------------------------------------------------------------------------------

### `nuke`

* Cuando recibe una señal la envía a todos los procesos del sistema, excepto a si mismo y a toda la jerarquía de procesos padre hasta `init`
* Implementa manejo de errores y avisa cuando no pudo enviar una señal y explica por qué no se pudo

+ <https://linux.die.net/man/3/kill>
+ <https://linux.die.net/man/3/errno>
+ <https://linux.die.net/man/3/explain>
+ <https://linux.die.net/man/3/explain_kill>
+ <https://linux.die.net/man/2/fork>
+ <https://linux.die.net/man/7/pthreads>
+ <https://linux.die.net/man/3/kill>
+ <https://linux.die.net/man/3/pthread_kill>

--------------------------------------------------------------------------------

### `octal-mode`

* Crea todas las posibilidades de permisos en **archivos** y **directorios**, desde `0000` hasta `7777`
  - Tomar en cuenta los permisos usuales para `user`, `group` y `other`
  - El primer dígito corresponde a los bits `suid`, `sgid` y `sticky`
* Para los **archivos** comprueba que se puedan _abrir_, _leer_, _modificar_ y _borrar_
* Para los **directorios** comprueba que se pueda _cambiar al directorio_, _listar el contenido_, así como _crear_ y _borrar_ archivos dentro de ellos

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

--------------------------------------------------------------------------------

### `shell`

Lee los comandos desde la entrada estándar y los ejecuta conectando la salida estándar y el error estándar a cada proceso hijo

* Lee el comando a ejecutar y sus argumentos desde `STDIN`
* Al recibir un retorno de línea ejecuta el comando con los argumentos especificados
* Imprime el código de salida del último comando ejecutado en el _prompt_
* El _prompt_ debe ser el caracter `#` si el usuario es `root` o el caracter `$` en caso contrario
* Soporta los siguientes comandos:
  - `cd`: Cambia al directorio especificado
  - `pwd`: Imprime la ruta del directorio actual
  - `exit`: Termina el programa

```
$ uname -a
Linux 0a1b2c3d4e5f 4.9.125-linuxkit #1 SMP Fri Sep 7 08:20:28 UTC 2018 x86_64 Linux
0
$ cat /archivo/que/no/existe
1
$ cd /tmp
$ pwd
/tmp
$ exit
```

+ <https://git.busybox.net/busybox/tree/shell>
+ <https://linux.die.net/man/2/fork>
+ <https://linux.die.net/man/3/exec>
+ <https://linux.die.net/man/3/system>

--------------------------------------------------------------------------------

### `hashdeep`

* Calcula la _suma de verificación_ **md5** y **sha1** de un archivo utilizando procesos o hilos diferentes
* La lista de archivos se puede pasar como argumentos al programa o vía `STDIN` (un archivo por línea)
* Realizar la _suma de verificación_ de cada archivo de entrada en un proceso o hilo separado
* Al terminar de procesar el archivo imprimir el resultado en `STDOUT` con el siguiente formato separado por `\t`

```
$ printf "" > vacio

$ ls -la vacio 
-rw-r--r--  1 tonejito  staff  0 Dec 14 22:28 vacio

$ md5sum vacio
d41d8cd98f00b204e9800998ecf8427e  vacio

$ shasum vacio
da39a3ee5e6b4b0d3255bfef95601890afd80709  vacio
```

```
./hashdeep vacio
nombre	tamaño	md5	sha1
vacio	0	d41d8cd98f00b204e9800998ecf8427e	da39a3ee5e6b4b0d3255bfef95601890afd80709
```

+ <https://linux.die.net/man/1/hashdeep>
+ <https://linux.die.net/man/3/md5_init>
+ <https://linux.die.net/man/3/sha>
+ <https://www.gnu.org/software/parallel/>
+ <https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/crypto/md5.c>
+ <https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/crypto/sha1_generic.c>

--------------------------------------------------------------------------------

### `rainbow`

* Demonio que recibe una cadena desde `STDIN` y la guarda en memoria junto con su _hash_ **md5** y **sha1**
* Atiende a los clientes utilizando procesos o hilos
* Al recibir la señal `HUP` imprime el contenido de la memoria en `STDOUT`
* Al recibir la señal `INT` guarda el contenido de la memoria en un archivo separado por `\t`
* Al iniciar carga el contenido de este archivo en memoria si es que existe
* Implementar mecanismos de sincronización para evitar condiciones de carrera e interbloqueos

+ <https://en.m.wikipedia.org/wiki/Rainbow_table>

--------------------------------------------------------------------------------

### `rinetd`

* Demonio que escucha conexiones **TCP** en `bindaddress`:`bindport`
* Atiende a los clientes utilizando procesos o hilos
* Cada conexión que recibe es redireccionada a `connectaddress`:`connectport`
* Lee su configuración desde un archivo separado por `\t`

```
bindadress	bindport	connectaddress	connectport
```

+ <https://manpages.debian.org/stretch/rinetd/rinetd.8.en.html>

--------------------------------------------------------------------------------

### `nmap`

* Crea N procesos o hilos y cada uno verifica que se pueda conectar a un puerto TCP del host de destino
* El rango o lista de puertos se pasan por línea de comandos
* El último argumento es el host a escanear, ya sea como dirección IPv4, IPv6 o nombre DNS
* Al final muestra un resumen de los puertos que incluye el nombre y número de puerto, utilizar `/etc/services`

+ <https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers#Well-known_ports>
+ <https://linux.die.net/man/3/getservent>

--------------------------------------------------------------------------------

### `memcached`

* Demonio que implementa el protocolo MemCache con los comandos `set`, `get`, `delete`, `flush` y `stats`
* Soporta varios clientes por socket UNIX, TCP o UDP y los atiende utilizando procesos o hilos
* Establecer un arreglo en memoria de tamaño configurable en KB y agregar dos instrucciones:
  - `save`: para guardar el estado del arreglo de memoria a disco
  - `load`: para cargar el estado del arreglo de memoria desde disco
* Implementar mecanismos de sincronización para evitar condiciones de carrera e interbloqueos

+ <https://github.com/memcached/memcached>
+ <https://github.com/memcached/memcached/blob/master/doc/protocol.txt>
+ <https://github.com/memcached/memcached/blob/master/doc/threads.txt>

--------------------------------------------------------------------------------

### `nsca_httpd`

* Servidor web que implementa los métodos `GET` y `HEAD`, así como los códigos de estado `200`, `403`, `404` y `500`
* El directorio raíz del servidor es pasado como primer argumento al programa o como la variable de entorno `DocumentRoot`
* Imprime la bitácora de acceso a `STDOUT` y la bitácora de errores a `STDERR`
* Atiende a los clientes utilizando procesos o hilos

+ <https://en.wikipedia.org/wiki/List_of_HTTP_status_codes>
+ <https://en.wikipedia.org/wiki/List_of_HTTP_header_fields>
+ <https://en.wikipedia.org/wiki/Common_Log_Format>
+ <https://httpd.apache.org/docs/2.4/logs.html>

--------------------------------------------------------------------------------

### `backdoor`

Para tener todos los puntos de este programa implementar los 3 componentes (`servidor`, `local` y `remoto`)

#### Programa **servidor**

* El programa **servidor** escucha conexiones por TCP y socket UNIX
* Conecta internamente el socket del _primer cliente TCP_ con el _primer cliente UNIX_
* Las conexiones pueden ser atendidas por procesos o hilos

#### Programa **local**

* El programa **local** se conecta al servidor via socket UNIX
* Este programa _envía_ comandos al programa **remoto**
* Conecta `STDIN` a la parte del socket que envía
* Conecta `STDOUT` y `STDERR` a la parte del socket que recibe

#### Programa **remoto**

* El programa **remoto** se conecta al servidor via TCP
* Este programa _recibe_ comandos desde el programa **local**
* Conecta `STDIN` a la parte del socket que recibe
* Conecta `STDOUT` y `STDERR` a la parte del socket que envía
* Al establecer una conexión ejecuta el programa especificado por la _variable de entorno_ `SHELL`

+ <https://linux.die.net/man/3/socket>
+ <https://linux.die.net/man/3/bind>
+ <https://linux.die.net/man/3/listen>
+ <https://linux.die.net/man/3/accept>

--------------------------------------------------------------------------------
