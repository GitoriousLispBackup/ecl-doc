XMLTO = xmlto
XSLTPROC = xsltproc

GEN_XMLFILES= tmp/COPYING.GFDL.xml
XMLFILES= ecl.xml bibliography.xmlf clos.xmlf compiler.xmlf			\
	declarations.xmlf ecldev.xmlf						\
	internals.xmlf interpreter.xmlf preface.xmlf				\
	io.xmlf mp.xmlf asdf.xmlf os.xmlf pde.xmlf				\
	copyright.xmlf ffi.xmlf ref_os.xmlf					\
	uffi/ref_primitive.xml uffi/ref_aggregate.xml uffi/ref_object.xml	\
	uffi/ref_string.xml uffi/ref_func_libr.xml				\
	mp.xmlf ref_mp.xmlf memory.xmlf ref_memory.xmlf				\
	mop.xmlf embed.xmlf ref_embed.xmlf signals.xmlf				\
	ansi_arrays.xml ansi_overview.xml					\
	ansi_characters.xml ansi_packages.xml ansi_conses.xml			\
	ansi_printer.xml ansi_data_flow.xml ansi_reader.xml			\
	ansi_environment.xml ansi_sequences.xml	ansi_evaluation.xml		\
	ansi_streams.xml ansi_filenames.xml ansi_strings.xml			\
	ansi_files.xml ansi_structures.xml ansi_hash_tables.xml			\
	ansi_symbols.xml ansi_numbers.xml ansi_system_construction.xml		\
	ansi_objects.xml ansi_types.xml						\
	ref_c_evaluation.xml ref_c_data_flow.xml ref_c_symbols.xml		\
	ref_c_numbers.xml ref_c_characters.xml ref_c_strings.xml		\
	ref_c_conses.xml ref_c_hash_tables.xml ref_c_sequences.xml		\
	ref_c_filenames.xml ref_c_packages.xml ref_c_printer.xml		\
	ref_c_system_construction.xml ref_c_environment.xml			\
	ref_c_objects.xml ref_c_conditions.xml ref_c_structures.xml		\
	ref_signals.xmlf ref_c_arrays.xml $(GEN_XMLFILES)

XSLFILES= xsl/customization.xml xsl/lispfunc.xml xsl/refentryintoc.xml

all: html/ecl.css

html/index.html: $(XMLFILES) $(XSLFILES) xsl/add_indexterm.xml
	@test -d html || mkdir html
	$(XSLTPROC) --xinclude xsl/add_indexterm.xml ecl.xml | \
	sed 's, xmlns="",,g' > html/ecl2.xml
	$(XMLTO) -vv --skip-validation $(subst xsl, -m xsl,$(XSLFILES)) -o html html html/ecl2.xml
	rm html/ecl2.xml
	cp ecl.css html/
html/ecl.css: ecl.css html/index.html
	cp ecl.css html/
	@test -d html/figures || mkdir html/figures
	cp figures/*.png html/figures/

ecl.pdf: $(XMLFILES) $(XSLFILES)
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
