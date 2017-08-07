SHELL=/bin/bash

SRC=index.md
DST=$(shell basename ${SRC} .md).html

convert:	${SRC}
	pandoc -f Markdown -t html5 -i ${SRC} -o ${DST}
