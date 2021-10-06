# Tipos de archivo en sistemas UNIX

+ <https://en.wikipedia.org/wiki/Unix_file_types>
+ <http://www.tldp.org/LDP/intro-linux/html/sect_03_01.html>
+ <https://www.linux.com/blog/file-types-linuxunix-explained-detail>
+ <https://www.unixtutorial.org/2007/09/unix-file-types/>
+ <https://www.linuxnix.com/file-types-in-linux/>

|Tipo| Nombre			 | Ejemplo
|:--:|:-------------------------:|:-------------------------
|`-` | Archivo normal		 | `/etc/issue`
|`d` | Directorio		 | `/home/`
|`l` | Liga simbólica		 | `/dev/fd` -> `/proc/self/fd`
|`p` | FIFO (named pipe)	 | `/run/initctl`
|`s` | Socket de dominio de UNIX | `/run/docker.sock`
|`b` | Dispositivo de bloques	 | `/dev/sda`
|`c` | Dispositivo de caracteres | `/dev/zero`

--------------------------------------------------------------------------------

## 1 - Archivo normal

- Representa un archivo que se guarda en el equipo

## 2 - Directorio

- Representa un archivo de tipo directorio
- Se guarda la referencia en el sistema de archivos para ayudar a organizar los archivos

```
$ mkdir -vp ~/.local/bin
mkdir: created directory '/home/tonejito/.local'
mkdir: created directory '/home/tonejito/.local/bin'
```

## 3 - Liga simbólica

- Contiene la ruta relativa o absoluta del archivo a la que hace referencia
- Al leerlo o escribirlo se hara referencia al archivo destino

```
# ln -vs /usr/bin/codium /usr/local/bin/code
'/usr/local/bin/code' -> '/usr/bin/codium'

# ls -la /usr/local/bin/code /usr/bin/codium
lrwxrwxrwx 1 root root 28 Oct 10 00:18 /usr/bin/codium -> /usr/share/codium/bin/codium
lrwxrwxrwx 1 root root 15 Oct 20 01:16 /usr/local/bin/code -> /usr/bin/codium
```

### Liga dura

Las _ligas duras_ no tienen un tipo de archivo definido, estas son apuntadores adicionales a un archivo normal que tienen un nombre diferente.

Los archivos tienen 1 liga de manera predeterminada (`nlinks=1`):

```
$ ls -lA .bashrc
-rw-r--r-- 1 tonejito users 4326 Oct 15 09:44 .bashrc
```

Al crear una _liga dura_ se incrementa el número a 2 (`nlinks=2`)

```
$ ln -v .bashrc mi-archivo-bashrc
'mi-archivo-bashrc' => '.bashrc'

$ ls -lA .bashrc mi-archivo-bashrc
-rw-r--r-- 2 tonejito users 4326 Oct 15 09:44 .bashrc
-rw-r--r-- 2 tonejito users 4326 Oct 15 09:44 mi-archivo-bashrc
```

Al crear otra _liga dura_ se incrementa el número a 3 (`nlinks=3`)

```
$ ln -v .bashrc otra-liga-hacia-bashrc
'otra-liga-hacia-bashrc' => '.bashrc'

$ ls -lA .bashrc mi-archivo-bashrc otra-liga-hacia-bashrc
-rw-r--r-- 3 tonejito users 4326 Oct 15 09:44 .bashrc
-rw-r--r-- 3 tonejito users 4326 Oct 15 09:44 mi-archivo-bashrc
-rw-r--r-- 3 tonejito users 4326 Oct 15 09:44 otra-liga-hacia-bashrc
```

Para mas información consultar la sección de sistemas de archivos.

## 4 - FIFO - Named Pipe

Archivo en el que se leen los datos en el mismo orden que se escribieron

1. Crear un FIFO:

```
$ mkfifo mi-pipe

$ ls -la mi-pipe
prw-r--r-- 1 tonejito users 0 Oct 20 01:22 mi-pipe
```

2. Escribir contenido en el FIFO:

```
$ cat > mi-pipe << EOF
> Hola
> Esto se está escribiendo a un FIFO
> y será leído en el orden que se escribió
> EOF
```

3. Abrir otra terminal y leer desde el FIFO:

```
$ cat mi-pipe
Hola
Esto se está escribiendo a un FIFO
y será leído en el orden que se escribió
```

4. Al terminar de leer, la terminal de (2) termina el proceso `cat`

5. Si se intenta leer otra vez, la lectura se quedará en espera hasta que haya datos en el FIFO

## 5 - UNIX Domain Socket

- Se utiliza para IPC (comunicación entre procesos)
- Un _proceso servidor_ abre el socket y uno o varios clientes se conectan a el
- Según la lógica del _proceso servidor_, cada cliente será atendido por un subproceso o un hilo
- El socket se crea con la llamada al sistema `bind(2)`

## Dispositivos

Se crean con el comando `mknod(1)`

### 6 - Dispositivo de bloques

Se leen bloques de información de un tamaño dado, comúnmente estos dispositivos son asignados a discos duros donde el tamaño del bloque es como mínimo 512 bytes.

### 7 - Dispositivo de caracteres

Se lee o escribe la información byte por byte en estos dispositivos, ejemplos comúnes son `/dev/zero` y `/dev/null`.

--------------------------------------------------------------------------------

### Comandos útiles

Encuentra las ligas simbólicas en el directorio `${HOME}`

```
$ find ${HOME} -type l -ls
```

Encuentra dispositivos de bloques o de caracteres en el directorio `/dev`:

```
# find /dev \( -type b -o -type c \) -ls
```

Encuentra los archivos que **no** sean "archivos regulares", directorios ni ligas simbólicas:

```
# find / ! \( -type f -o -type d -o -type l \) -ls
```
