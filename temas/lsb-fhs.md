# Linux Standard Base - LSB
## Filesystem Hierarchy Standard - FHS

+ <https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html>
+ <https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard>

| Carpeta                               | Descripción
|:--------------------------------------|:------------
|`/`					| Raíz del sistema de archivos
|├── `boot`				| Guarda el kernel, initrd y configuración del cargador de inicio
|├── `bin`				| Programas esenciales para todos los usuarios
|├── `sbin`				| Programas esenciales para el _superusuario_
|├── `root`				| Directorio `${HOME}` del usuario _superusuario_
|├── `dev`				| Contiene los _nodos de dispositivo_
|├── `etc`				| Contiene las configuraciones del sistema operativo
|├── `home`				| Directorios personales de cada usuario
|├── `lib`				| Bibliotecas esenciales del sistema operativo
|├── `lib64`				| Bibliotecas esenciales para arquitectura de 64 bits
|├── `mnt`				| Puntos de montaje manualaes
|├── `media`				| Puntos de montaje administrados por el _automounter_
|├── `opt`				| Archivos de software de terceros
|├── `srv`				| Contenido para algunos servicios de red como NFS y TFTP
|├── `tmp`				| Archivos temporales no persistentes
|├── `run`				| Archivos volátiles asociados a servicios del sistema
|├── `proc`				| (Linux) Permite visualizar elementos del _kernel_ en ejecución
|│   ├── `<PID>`			| También permite ver el contexto de ejecución de los procesos del sistema
|│   ├── `config`			| Configuración de compilación para el _kernel_ (opcional)
|│   ├── `cmdline`			| Línea de comandos para el _kernel_ en ejecución
|│   ├── `bus`				|
|│   ├── `driver`			|
|│   ├── `fs`				|
|│   ├── `sys`				|
|│   ├── `sysvipc`			|
|│   └── `tty`				|
|├── `sys`				| (Linux) Permite visualizar la configuración actual del _kernel_ por subsistema
|│   ├── `block`			|
|│   ├── `bus`				|
|│   ├── `class`			|
|│   ├── `dev`				|
|│   ├── `devices`			|
|│   ├── `firmware`			|
|│   ├── `fs`				|
|│   ├── `hypervisor`			|
|│   ├── `kernel`			|
|│   ├── `module`			|
|│   └── `power`			|
|├── `usr`				| _Secondary Root_: _Software_ instalado desde paquetes
|│   ├── `bin`				| - Programas no esenciales para todos los usuarios
|│   ├── `include`			| - Archivos de cabecera para compilación de _software_
|│   ├── `lib`				| - Bibliotecas no esenciales
|│   ├── `local`			| _Tertiary Root_: _Software_ compilado desde código fuente
|│   │   ├── `bin`			|
|│   │   ├── `include`			|
|│   │   ├── `sbin`			|
|│   │   ├── `share`			|
|│   │   └── `src`			|
|│   ├── `sbin`				| - Programas no esenciales para el superusuario (ejecutables de servicios del sistema)
|│   ├── `share`			| - Archivos independientes de arquitectura
|│   └── `src`				| - Código fuente del kernel y módulos
|└── `var`				| Archivos variables
|    ├── `backups`			| - Respaldos
|    ├── `cache`			| - Caché
|    ├── `lib`				| - Datos persistentes de servicios del sistema
|    ├── `local`			|
|    ├── `lock -> /run/lock`		|
|    ├── `log`				| - Bitácoras
|    ├── `mail`				| - Buzones de correo
|    ├── `opt`				|
|    ├── `run -> /run`			|
|    ├── `spool`			|
|    └── `tmp`				| - Archivos temporales persistentes

