
SHELL = /bin/bash
ALL_GV = $(wildcard *.gv)
ALL_HTML = $(patsubst %.gv,out/%.html,$(ALL_GV))

.PHONY: default
default: first $(ALL_HTML)

.PHONY: first
first:
	type -a -path dot
	mkdir -p out tmp

out/%.html: tmp/%.map tmp/%.svg.base64 generic.html.m4
	/opt/local/bin/gm4 -P -DM_NAME=$* generic.html.m4 > $@

tmp/%.map: tmp/%.map.orig map.sed
	sed -f map.sed $< > $@

tmp/%.map.orig tmp/%.svg: %.gv
	dot -Tsvg -otmp/$*.svg -Tcmapx -otmp/$*.map.orig $<

tmp/%.svg.base64: tmp/%.svg
	base64 $< > $@

.PHONY: clean
clean:
	$(RM) -r out tmp
	$(RM) $(wildcard *~)

.SECONDARY:
