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

- La fecha límite de entrega es el **miércoles 19 de enero de 2022** a las 23:59 horas
- Esta actividad debe ser entregada **por equipo** de acuerdo al [flujo de trabajo para la entrega de tareas y prácticas][flujo-de-trabajo]
    - Crear un _merge request_ en el [repositorio de tareas][repo-tareas] para entregar la actividad

--------------------------------------------------------------------------------

## Entregables

Se deben entregar los siguientes elementos en la carpeta `entregas/practica-6`

- Documentación en el archivo `README.md`
- Archivo `Dockerfile`
- Código de los programas en C
- Archivo `Makefile` para compilación
- _Script_ de _shell_ para pruebas
- Bitácoras de compilación y pruebas del programa en texto plano
    - No entregar capturas de pantalla ni archivos PDF

--------------------------------------------------------------------------------

## Lineamientos

Escribir un archivo `Makefile` que cumpla con los siguientes requisitos:

- En el `Dockerfile` usar las etiquetas: `FROM`, `WORKDIR`, `RUN`, `EXPOSE`, `WORKDIR`, `COPY`, `CMD` 
- El archivo `Makefile` debe construir el contenedor (docker build -t TAG .)
- Realizar push del contenedor a Docker Hub
- Correr el contenedor en modo interactivo, exponer el puerto y monte algún directorio como htdocs (docker run -it -p 8080:80 -v ${PWD}:/opt/htdocs fulanito/servidor:latest)

--------------------------------------------------------------------------------

## Recomendaciones

<!-- -->
- Hacer uso de [Docker Buildkit][Docker-Buildkit]
<!-- -->

--------------------------------------------------------------------------------

[flujo-de-trabajo]: https://sistemasoperativos-ciencias-unam.gitlab.io/2022-1/tareas-so/workflow/
[repo-tareas]: https://gitlab.com/SistemasOperativos-Ciencias-UNAM/2022-1/tareas-so.git
[Docker-Buildkit]: https://docs.docker.com/engine/reference/builder/