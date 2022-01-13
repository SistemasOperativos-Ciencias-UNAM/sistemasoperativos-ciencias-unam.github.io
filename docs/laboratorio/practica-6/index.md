---
# https://www.mkdocs.org/user-guide/writing-your-docs/#meta-data
title: Servidor web con Docker
authors:
- José Antonio Martínez Balderas
---

# Servidor web con Docker

Práctica 6

## Objetivo

- Familiarizar al alumno con el uso de Dockerfile para desplegar contenedores
- Implementar un servidor web a través de Docker

--------------------------------------------------------------------------------

## Restricciones

- La fecha límite de entrega es el **jueves 20 de enero de 2022** a las 23:59 horas
- Esta actividad debe ser entregada **por equipo** de acuerdo al [flujo de trabajo para la entrega de tareas y prácticas][flujo-de-trabajo]
    - Crear un _merge request_ en el [repositorio de tareas][repo-tareas] para entregar la actividad

--------------------------------------------------------------------------------

## Elementos de apoyo

- Videos:
    - [Introducción a Docker - Parte 1 📼][video-intro-docker-parte-1]
    - [Introducción a Docker - Parte 2 📼][video-intro-docker-parte-2]
- Guías y documentación:
    - [Guía básica de Docker][docker-get_started]
    - [Tutorial de Docker][docker-tutorial]
    - [Laboratorio interactivo de Docker][docker-play]
    - [Libro en línea de Docker][docker-curriculum]
- Referencia de comandos:
    - [Referencia de `Dockerfile`][dockerfile-reference]
    - [Referencia de `BuildKit` para Docker][docker-buildkit]
    - [Referencia de _multi-stage_ en `Dockerfile`][docker-multistage]
- [Imagenes de Debian en Docker Hub][dockerhub-debian]

--------------------------------------------------------------------------------

## Entregables

Se deben entregar los siguientes elementos en la carpeta `entregas/practica-6`

- Documentación en el archivo `README.md`
- Archivo `Makefile` para compilación
- Archivo `Dockerfile` para construir el contenedor utilizando el mecanismo [multi-stage][docker-multistage]
- Código en C del servidor web de la [práctica 5](../practica-5) (copiar el archivo que ya tienen)
- Bitácoras de la construcción del contenedor en texto plano
    - No entregar capturas de pantalla ni archivos PDF

--------------------------------------------------------------------------------

## Lineamientos

Escribir un archivo `Makefile` que cumpla con los siguientes requisitos:

- En el `Dockerfile` usar las etiquetas: `FROM`, `WORKDIR`, `RUN`, `EXPOSE`, `WORKDIR`, `COPY`, `CMD` 
- Construir el contenedor utilizando el mecanismo [multi-stage][docker-multistage]
    - Utilizar la imágen [`debian:11-slim`][dockerhub-debian] como base para todas las fases de construcción del contenedor
    - Copiar el código fuente en C del servidor web hacia el contenedor
    - La primer fase instala las dependencias de desarrollo y compila el servidor web
    - La segunda fase copia el binario del servidor web obtenido en la primer fase y asigna las demás directivas para poder ejecutar el contenedor y exponer el puerto

- Ejemplo de [Dockerfile con multi-stage][dockerfile-multistage-example]
```Dockerfile
################################################################################
# Define la primer fase de construcción, donde se compila el código en C
FROM debian:11-slim AS builder
# Demás directivas de configuración para la imagen que compila

################################################################################
# Define la segunda fase donde se configura el contenedor que ejecuta la aplicación
# Copiar el binario compilado en la fase anterior
FROM debian:11-slim AS app
COPY --from=builder servidor-web ./
# Demás directivas de configuración para la imagen que ejecuta la aplicación
```

- El archivo `Makefile` debe construir el contenedor y ejecutarlo
    - `docker build -t ${TAG} .`
    - Realizar push del contenedor resultante a Docker Hub
    - Correr el contenedor en modo interactivo
        - Exponer el puerto TCP donde el servidor recibe conexiones de los clientes
        - Montar algún directorio como htdocs
        - `docker run -it -p 8080:80 -v ${PWD}:/opt/htdocs fulanito/servidor:latest`

--------------------------------------------------------------------------------

[flujo-de-trabajo]: https://sistemasoperativos-ciencias-unam.gitlab.io/2022-1/tareas-so/workflow/
[repo-tareas]: https://gitlab.com/SistemasOperativos-Ciencias-UNAM/2022-1/tareas-so.git

[video-intro-docker-parte-1]: https://www.youtube.com/watch?v=jhf-8I6zHoU&list=PLa3Cxza-egQWixsZtom-qU_85A2QgjF5U&index=48
[video-intro-docker-parte-2]: https://www.youtube.com/watch?v=WpfQ8WWOYYA&list=PLa3Cxza-egQWixsZtom-qU_85A2QgjF5U&index=49

[docker-get_started]: https://docs.docker.com/get-started/overview/
[docker-tutorial]: https://www.docker.com/101-tutorial
[docker-play]: https://labs.play-with-docker.com/
[docker-curriculum]: https://docker-curriculum.com/

[dockerfile-reference]: https://docs.docker.com/engine/reference/builder/
[docker-buildkit]: https://docs.docker.com/develop/develop-images/build_enhancements/
[docker-multistage]: https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds
[dockerfile-multistage-example]: https://github.com/J-Rios/TLG_JoinCaptchaBot/blob/master/docker/Dockerfile

[dockerhub-debian]: https://hub.docker.com/_/debian
