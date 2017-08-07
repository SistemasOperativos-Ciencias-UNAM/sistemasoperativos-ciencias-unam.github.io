SHELL=/bin/bash

RM=/bin/rm
PANDOC=/usr/bin/pandoc

NAME=index
SRC=${NAME}.md
DST=${NAME}.html

convert:	${SRC}
	${PANDOC} -f Markdown -t html5 -i ${SRC} -o ${DST}

clean:	${DST}
	if [ -e ${DST} ] ; then ${RM} -v ${DST} ; fi ;
