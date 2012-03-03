LANG=de
POFILE="po/${LANG}/gli.po"
MOFILE="po/${LANG}/gli.mo"

all: pofile mofile

pofile:
	rgettext gli > all.po
	touch ${POFILE}
	msgmerge -o ${POFILE}.new ${POFILE} all.po
	mv ${POFILE}.new ${POFILE}
	rm -f all.po

mofile:
	msgfmt -o ${MOFILE} ${POFILE}
	cp ${MOFILE} "/usr/share/locale/${LANG}/LC_MESSAGES/"
