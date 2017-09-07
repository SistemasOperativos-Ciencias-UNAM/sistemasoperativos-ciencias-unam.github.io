SHELL=/bin/bash

RM=rm
TIDY=tidy
PANDOC=pandoc

TITLE=Sistemas Operativos - Facultad de Ciencias - UNAM
NAME=index
SRC=${NAME}.md
DST=public/${NAME}.html

all:
	$(MAKE) index.html practica-pthreads.html

%.html: %.md
	${PANDOC} -f Markdown -t html5 --self-contained -T "${TITLE}" -i $< -o public/$@
	${TIDY} -quiet -indent -wrap 0 -utf8 -modify public/$@ || true

clean:	${DST}
	if [ -e ${DST} ] ; then ${RM} -v ${DST} ; fi ;
