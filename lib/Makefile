LANG=de
POFILE="po/${LANG}/gli-lib.po"
MOFILE="po/${LANG}/gli-lib.mo"

all: pofile mofile

pofile:
	cat gli.rb gli_version.rb gli/*.rb support/*.rb > all.tmp
	rgettext all.tmp > all.po
	rm -f all.tmp
	touch ${POFILE}
	msgmerge -o ${POFILE}.new ${POFILE} all.po
	mv ${POFILE}.new ${POFILE}
	rm -f all.po

mofile:
	msgfmt -o ${MOFILE} ${POFILE}
	cp ${MOFILE} "/usr/share/locale/${LANG}/LC_MESSAGES/"
