XMLTO = xmlto

GEN_XMLFILES= tmp/COPYING.GFDL.xml
XMLFILES= ecl.xml bibliography.xmlf clos.xmlf compiler.xmlf			\
	declarations.xmlf ecldev.xmlf						\
	internals.xmlf interpreter.xmlf preface.xmlf				\
	io.xmlf mp.xmlf asdf.xmlf os.xmlf pde.xmlf				\
	standards.xmlf copyright.xmlf ffi.xmlf ref_os.xmlf			\
	uffi/ref_primitive.xml uffi/ref_aggregate.xml uffi/ref_object.xml	\
	uffi/ref_string.xml uffi/ref_func_libr.xml				\
	mp.xmlf ref_mp.xmlf memory.xmlf ref_memory.xmlf				\
	mop.xmlf embed.xmlf ref_embed.xmlf signals.xmlf				\
	ref_c_evaluation.xml ref_c_data_flow.xml ref_c_symbols.xml		\
	ref_c_numbers.xml ref_c_characters.xml ref_c_strings.xml		\
	ref_signals.xmlf ref_c_arrays.xml $(GEN_XMLFILES)

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

tmp/ecl.ent: ecl.ent
	cp $< $@

tmp/COPYING.GFDL.xml: COPYING.GFDL Makefile
	echo '<![CDATA[' > $@
	cat $< >> $@
	echo ']]>' >> $@

jing:
	java -jar ~/Downloads/jing-20081028/bin/jing.jar -t -i /usr/local/Cellar/docbook/5.0/docbook/xml/5.0/rng/docbookxi.rng ecl.xml

clean:
	rm -f tmp/ecl.ent $(GEN_XMLFILES) html/*.html
