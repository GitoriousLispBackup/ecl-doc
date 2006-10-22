XMLTO = xmlto

XMLFILES= ecl.xml tmp/bibliography.xml tmp/clos.xml tmp/compiler.xml	\
	tmp/declarations.xml tmp/ecldev.xml tmp/gc.xml			\
	tmp/internals.xml tmp/interpreter.xml tmp/preface.xml		\
	tmp/io.xml tmp/macros.xml tmp/mp.xml tmp/os.xml tmp/pde.xml	\
	tmp/standards.xml tmp/copyright.xml tmp/ffi.xml			\
	tmp/ref_os.xml

XSLFILES= xsl/lispfunc.xml xsl/customization.xml xsl/refentryintoc.xml

all: html/ecl.css

html/index.html: $(XMLFILES)
	@test -d html || mkdir html
	$(XMLTO) $(subst xsl, -m xsl,$(XSLFILES)) -o html html ecl.xml
	cp ecl.css html/
html/ecl.css: ecl.css html/index.html
	cp ecl.css html/
	@test -d html/figures || mkdir html/figures
	cp figures/*.png html/figures/

ecl.pdf: $(XMLFILES)
	$(XMLTO) -o $@ pdf ecl.xml

tmp/%.xml: %.xmlf Makefile
	@test -d tmp || mkdir tmp
	grep -v '<\(!DOCTYPE\|book\|/book\)'  $< > $@
