XMLTO = xmlto

XMLFILES= ecl.xml tmp/bibliography.xml tmp/clos.xml tmp/compiler.xml	\
	tmp/declarations.xml tmp/ecldev.xml 				\
	tmp/internals.xml tmp/interpreter.xml tmp/preface.xml		\
	tmp/io.xml tmp/mp.xml tmp/asdf.xml tmp/os.xml tmp/pde.xml	\
	tmp/standards.xml tmp/copyright.xml tmp/ffi.xml tmp/ref_os.xml	\
	tmp/ref_primitive.xml tmp/ref_aggregate.xml tmp/ref_object.xml	\
	tmp/ref_string.xml tmp/ref_func_libr.xml tmp/COPYING.GFDL.xml   \
	tmp/mp.xml tmp/ref_mp.xml tmp/memory.xml tmp/ref_memory.xml  	\
	tmp/mop.xml tmp/embed.xml tmp/ref_embed.xml

XSLFILES= xsl/lispfunc.xml xsl/customization.xml xsl/refentryintoc.xml

all: html/ecl.css

html/index.html: $(XMLFILES)
	@test -d html || mkdir html
	$(XMLTO) --skip-validation $(subst xsl, -m xsl,$(XSLFILES)) -o html html ecl.xml
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

tmp/%.xml: uffi/%.xml Makefile
	@test -d tmp || mkdir tmp
	grep -v '<\(!DOCTYPE\|book\|/book\)'  $< > $@

tmp/COPYING.GFDL.xml: COPYING.GFDL Makefile
	echo '<![CDATA[' > $@
	cat $< >> $@
	echo ']]>' >> $@
