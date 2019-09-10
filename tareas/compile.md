# Programas de sistema de archivos, procesos, hilos y señales

## Objetivo

+ Realizar la configuración y compilación de un programa en Linux o UNIX

-------------------------------------------------------------------------------

## Lineamientos

+ Entregar un script o Makefile para realizar el proceso de forma automática
+ Instalar los binarios estáticos en `/usr/local`
+ Instalar los binarios dinámicos en `${HOME}/local`
  - Agregar `${HOME}/local/bin` y  `${HOME}/local/sbin` al `${PATH}`
  - Agregar `${HOME}/local/lib` a `${LD_LIBRARY_PATH}` con `ldconfig`
  - Agregar `${HOME}/local/include` a las rutas donde se buscan los archivos de cabecera
    * Pueden crear ligas simbólicas de `/usr/src/blah => ${HOME}/local/include

-------------------------------------------------------------------------------

## Restricciones

+ Levantar un _merge request_ en el [repositorio de tareas][repo-tareas] para avisar que ya se completó la tarea
+ Esta tarea debe ser entregada **individualmente**
+ Se debe redactar la documentación en el archivo `README.md`
+ El repositorio debe incluir un archivo `Makefile` que compile y realice las pruebas de cada programa
+ Se debe escribir un _script_ que ejecute el programa con las opciones y archivos de datos necesarios para realizar las pruebas

-------------------------------------------------------------------------------

## Requisitos

+ Compilador `cc`
+ Cabeceras estándar de GNU/Linux
+ Utilerías de desarrollo
  - `apt install build-essential`
  - `yum groupinstall 'Development Tools'`

-------------------------------------------------------------------------------

## Descargar código fuente

Encontrar un programa popular de código abierto que esté escrito en lenguaje C

+ <https://sourceforge.net/directory/language:c/os:linux/>
+ <https://gitlab.com/explore/projects/starred>
+ <https://github.com/topics/c?l=c>
+ <https://ftp.gnu.org/pub/gnu/>

Obtener la URL de descarga

+ Ejemplo: <https://github.com/nginx/nginx/archive/release-1.17.3.tar.gz>

Descargar el archivo `tar.gz` o `zip` con `wget`, `curl` o alguna herramienta similar

```
$ mkdir -vp ~/src
mkdir: created directory '/home/tonejito/src'

$ cd !$
cd ~/src

$ wget -c -nv -O 'git-2.23.0.tar.gz' 'https://github.com/git/git/archive/v2.23.0.tar.gz'
2019-09-10 07:28:46 URL:https://codeload.github.com/git/git/tar.gz/v2.23.0 [8647535] -> "git-2.23.0.tar.gz" [1]

```

-------------------------------------------------------------------------------

## Extraer el código fuente

Descomprimir el archivo `tar.gz` o `zip`

```
$ tar -xvvf git-2.23.0.tar.gz
drwxrwxr-x root/root         0 2019-08-16 17:28 git-2.23.0/
-rw-rw-r-- root/root      3273 2019-08-16 17:28 git-2.23.0/README.md
-rw-rw-r-- root/root    101879 2019-08-16 17:28 git-2.23.0/Makefile
-rw-rw-r-- root/root     38353 2019-08-16 17:28 git-2.23.0/configure.ac
	...
```

Cambiar al directorio con el código fuente e inspeccionar el contenido

```
$ cd git-2.23.0/
$ ls -A
```

-------------------------------------------------------------------------------

## Compilar los binarios

### Configurar programa

#### Uso de `autoconf` o `autoreconf`
En algunos casos es necesario utilizar `autoconf` o `autoreconf` para generar el _script_ `configure`. Para mas información, consultar el archivo `README` o `INSTALL`.

+ <https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/autoconf-2.69/autoconf.html#autoconf-Invocation>
+ <https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/autoconf-2.69/autoconf.html#autoreconf-Invocation>

Para el caso de ejemplo (`git`) es necesario utilizar `autoconf` porque solo existe el archivo `configure.ac`

```
$ ls -A configure*
configure.ac
```

Se ejecuta `autoconf` para generar el _script_ `configure`
 
```
$ autoconf
$ ls -A configure*
configure  configure.ac

```

#### Configurar el programa

```
$ ./configure --help 2>&1 | tee configure.help
`configure' configures git @@GIT_VERSION@@ to adapt to many kinds of systems.

Usage: ./configure [OPTION]... [VAR=VALUE]...

To assign environment variables (e.g., CC, CFLAGS...), specify them as
VAR=VALUE.  See below for descriptions of some of the useful variables.

Defaults for the options are specified in brackets.

Configuration:
  -h, --help              display this help and exit
      --help=short        display options specific to this package
      --help=recursive    display the short help of all the included packages
  -V, --version           display version information and exit
  -q, --quiet, --silent   do not print `checking ...' messages
      --cache-file=FILE   cache test results in FILE [disabled]
  -C, --config-cache      alias for `--cache-file=config.cache'
  -n, --no-create         do not create output files
      --srcdir=DIR        find the sources in DIR [configure dir or `..']

Installation directories:
  --prefix=PREFIX         install architecture-independent files in PREFIX
                          [/usr/local]
  --exec-prefix=EPREFIX   install architecture-dependent files in EPREFIX
                          [PREFIX]

By default, `make install' will install all the files in
`/usr/local/bin', `/usr/local/lib' etc.  You can specify
an installation prefix other than `/usr/local' using `--prefix',
for instance `--prefix=$HOME'.

For better control, use the options below.

Fine tuning of the installation directories:

	....

Optional Features:

	...

Optional Packages:
  --with-PACKAGE[=ARG]    use PACKAGE [ARG=yes]
  --without-PACKAGE       do not use PACKAGE (same as --with-PACKAGE=no)
  --with-sane-tool-path=DIR-1[:DIR-2...:DIR-n]
                          Directories to prepend to PATH in build system and
                          generated scripts
  --with-lib=ARG          ARG specifies alternative name for lib directory
  --with-openssl          use OpenSSL library (default is YES)
                          ARG can be prefix for openssl library and headers
  --with-libpcre          synonym for --with-libpcre2
  --with-libpcre1         support Perl-compatible regexes via libpcre1
                          (default is NO)
                          ARG can be also prefix for libpcre library and
                          headers
  --with-libpcre2         support Perl-compatible regexes via libpcre2
                          (default is NO)
                          ARG can be also prefix for libpcre library and
                          headers
  --with-curl             support http(s):// transports (default is YES)
                          ARG can be also prefix for curl library and headers
  --with-expat            support git-push using http:// and https://
                          transports via WebDAV (default is YES)
                          ARG can be also prefix for expat library and headers
  --without-iconv         if your architecture doesn't properly support iconv
  --with-iconv=PATH       PATH is prefix for libiconv library and headers
                          used only if you need linking with libiconv
  --with-gitconfig=VALUE  Use VALUE instead of /etc/gitconfig as the global
                          git configuration file. If VALUE is not fully
                          qualified it will be interpreted as a path relative
                          to the computed prefix at runtime.
  --with-gitattributes=VALUE
                          Use VALUE instead of /etc/gitattributes as the
                          global git attributes file. If VALUE is not fully
                          qualified it will be interpreted as a path relative
                          to the computed prefix at runtime.
  --with-pager=VALUE      Use VALUE as the fall-back pager instead of 'less'.
                          This is used by things like 'git log' when the user
                          does not specify a pager to use through alternate
                          methods. eg: /usr/bin/pager
  --with-editor=VALUE     Use VALUE as the fall-back editor instead of 'vi'.
                          This is used by things like 'git commit' when the
                          user does not specify a preferred editor through
                          other methods. eg: /usr/bin/editor
  --with-shell=PATH       provide PATH to shell
  --with-perl=PATH        provide PATH to perl
  --with-python=PATH      provide PATH to python
  --with-zlib=PATH        provide PATH to zlib
  --with-tcltk            use Tcl/Tk GUI (default is YES)
                          ARG is the full path to the Tcl/Tk interpreter.
                          Bare --with-tcltk will make the GUI part only if
                          Tcl/Tk interpreter will be found in a system.
Some influential environment variables:
  CC          C compiler command
  CFLAGS      C compiler flags
  LDFLAGS     linker flags, e.g. -L<lib dir> if you have libraries in a
              nonstandard directory <lib dir>
  LIBS        libraries to pass to the linker, e.g. -l<library>
  CPPFLAGS    (Objective) C/C++ preprocessor flags, e.g. -I<include dir> if
              you have headers in a nonstandard directory <include dir>
  CPP         C preprocessor

Use these variables to override the choices made by `configure' or to help
it to find libraries and programs with nonstandard names/locations.

Report bugs to <git@vger.kernel.org>.
```

De la salida anterior se pueden observar varias cosas:

+ `PREFIX` es la ubicación donde se instalará el programa. El valor por defecto es `/usr/local`
+ `--with-PACKAGE[=AR$aG]` habilita el uso de otro programa para extender la funcionalidad (ej. OpenSSL para funciones criptográficas y soporte de SSL)
+  `--without-PACKAGE` deshabilita el uso de ese programa adicional
+ Existen banderas para el compilador o el _linker_. Vamos a utilizar la bandera `-static` para generar binarios estáticos

```
$ LDFLAGS=-static ./configure --prefix=${HOME}/local
configure: Setting lib to 'lib' (the default)
configure: Will try -pthread then -lpthread to enable POSIX Threads.
configure: CHECKS for site configuration
checking for gcc... gcc
checking whether the C compiler works... yes
checking for C compiler default output file name... a.out

	...

configure: creating ./config.status
config.status: creating config.mak.autogen
config.status: executing config.mak.autogen commands
```

### Compila programa

Ejecutar `make` para compilar el programa.

#### Dependencias

Es muy probable que al programa le falten dependencias y marque errores como este:

```
$ make
GIT_VERSION = 2.23.0
    * new build flags
    CC fuzz-commit-graph.o
In file included from commit-graph.h:7,
                 from fuzz-commit-graph.c:1:
cache.h:21:10: fatal error: zlib.h: No such file or directory
 #include <zlib.h>
          ^~~~~~~~
compilation terminated.
make: *** [Makefile:2365: fuzz-commit-graph.o] Error 1
```

##### Instalar dependencias

Es necesario instalar los paquetes `*-dev` o `*-devel` para proveer las bibliotecas y archivos de cabecera necesarios para compilar el programa. Ver la ayuda de `./configure --help`

```
# export DEBIAN_FRONTEND=noninteractive
# apt --quiet --assume-yes install libpcre2-dev libcurl4-openssl-dev libexpat1-dev zlib1g-dev
```

##### Compilar el programa

Una vez que esten instaladas las dependencias, ejecutar de nuevo `make` para compilar el programa

```
$ make
    CC fuzz-commit-graph.o
    CC fuzz-pack-headers.o
    CC fuzz-pack-idx.o
    CC credential-store.o
	...
    GEN bin-wrappers/test-line-buffer
    GEN bin-wrappers/test-svn-fe
    GEN bin-wrappers/test-tool
```

##### Examinar el programa compilado

Verificar que los binarios sean estáticos. A veces los programas compilados están en el directorio `output` o `bin`.

```
$ file git
git: ELF 64-bit LSB executable, x86-64, version 1 (GNU/Linux), statically linked, for GNU/Linux 3.2.0, BuildID[sha1]=248400d62254e174181ed98f3dab59203e89812f, with debug_info, not stripped

$ ldd git
	not a dynamic executable
```

### Instalar programa

Ejecutar `make install` para instalar los binarios y páginas de man en la carpeta `${PREFIX}` que se configuró, en este caso `${HOME}/local`

```
$ make install
    SUBDIR git-gui
    SUBDIR gitk-git
    SUBDIR templates
install -d -m 755 '/home/tonejito/local/bin'
install -d -m 755 '/home/tonejito/local/libexec/git-core'

	...
```

Listar el directorio `${HOME}/local`

```
$ ls -lA ${HOME}/local/bin/
total 92700
-rwxr-xr-x 129 tonejito users 20359480 Sep 10 08:02 git
-rwxr-xr-x   2 tonejito users   162747 Sep 10 08:02 git-cvsserver
-rwxr-xr-x   1 tonejito users   351673 Sep 10 08:02 gitk
-rwxr-xr-x 129 tonejito users 20359480 Sep 10 08:02 git-receive-pack
-rwxr-xr-x   2 tonejito users 12961792 Sep 10 08:02 git-shell
-rwxr-xr-x 129 tonejito users 20359480 Sep 10 08:02 git-upload-archive
-rwxr-xr-x 129 tonejito users 20359480 Sep 10 08:02 git-upload-pack
```

```
$ tree -d ${HOME}/local
/home/tonejito/local
├── bin
├── libexec
│   └── git-core
│       └── mergetools
└── share
    ├── git-core
    │   └── templates
    │       ├── branches
    │       ├── hooks
    │       └── info
    ├── git-gui
    │   └── lib
    │       └── msgs
    ├── gitk
    │   └── lib
    │       └── msgs
    ├── gitweb
    │   └── static
    ├── locale
    │   ├── en
    │   │   └── LC_MESSAGES
    │   ├── ...
    │   │   └── ...
    │   └── es
    │       └── LC_MESSAGES
    └── perl5
        ├── FromCPAN
        │   └── Mail
        └── Git
            ├── LoadCPAN
            │   └── Mail
            └── SVN
                └── Memoize

55 directories
```

#### Verificar la instalación

Inspeccionar los binarios instalados

```
$ file ${HOME}/local/bin/*
/home/tonejito/local/bin/git:                ELF 64-bit LSB executable, x86-64, version 1 (GNU/Linux), statically linked, for GNU/Linux 3.2.0, BuildID[sha1]=248400d62254e174181ed98f3dab59203e89812f, with debug_info, not stripped
/home/tonejito/local/bin/git-cvsserver:      Perl script text executable
/home/tonejito/local/bin/gitk:               POSIX shell script, UTF-8 Unicode text executable
/home/tonejito/local/bin/git-receive-pack:   ELF 64-bit LSB executable, x86-64, version 1 (GNU/Linux), statically linked, for GNU/Linux 3.2.0, BuildID[sha1]=248400d62254e174181ed98f3dab59203e89812f, with debug_info, not stripped
/home/tonejito/local/bin/git-shell:          ELF 64-bit LSB executable, x86-64, version 1 (GNU/Linux), statically linked, for GNU/Linux 3.2.0, BuildID[sha1]=de6c0b9de3295282f586a6d90d290a0cd2180c60, with debug_info, not stripped
/home/tonejito/local/bin/git-upload-archive: ELF 64-bit LSB executable, x86-64, version 1 (GNU/Linux), statically linked, for GNU/Linux 3.2.0, BuildID[sha1]=248400d62254e174181ed98f3dab59203e89812f, with debug_info, not stripped
/home/tonejito/local/bin/git-upload-pack:    ELF 64-bit LSB executable, x86-64, version 1 (GNU/Linux), statically linked, for GNU/Linux 3.2.0, BuildID[sha1]=248400d62254e174181ed98f3dab59203e89812f, with debug_info, not stripped
```

```
$ ldd ${HOME}/local/bin/*
/home/tonejito/local/bin/git:
	not a dynamic executable
/home/tonejito/local/bin/git-cvsserver:
	not a dynamic executable
/home/tonejito/local/bin/gitk:
	not a dynamic executable
/home/tonejito/local/bin/git-receive-pack:
	not a dynamic executable
/home/tonejito/local/bin/git-shell:
	not a dynamic executable
/home/tonejito/local/bin/git-upload-archive:
	not a dynamic executable
/home/tonejito/local/bin/git-upload-pack:
	not a dynamic executable
```

#### Veriricar el programa instalado

```
$ which git
/home/tonejito/local/bin/git
```

```
$ git clone https://gitlab.com/tonejito/empty.git
Cloning into 'empty'...
warning: You appear to have cloned an empty repository.
```

-------------------------------------------------------------------------------

[repo-tareas]: https://gitlab.com/SistemasOperativos-Ciencias-UNAM/2020-1/tareas-so.git
