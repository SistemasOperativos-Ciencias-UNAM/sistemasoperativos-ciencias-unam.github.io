SHELL=/bin/bash

RM=/bin/rm
TIDY=/usr/bin/tidy
PANDOC=/usr/bin/pandoc

TITLE=Sistemas Operativos - Facultad de Ciencias - UNAM
NAME=index
SRC=${NAME}.md
DST=public/${NAME}.html

convert:	${SRC}
	${PANDOC} -f Markdown -t html5 --self-contained -T "${TITLE}" -i ${SRC} -o ${DST}
	${TIDY} -quiet -indent -wrap 0 -utf8 -modify ${DST} || true

clean:	${DST}
	if [ -e ${DST} ] ; then ${RM} -v ${DST} ; fi ;
