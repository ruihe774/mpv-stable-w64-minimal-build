include Prelude.mk

UNARCHIVED = $(DOWNLOADS)/mingw64
ARCHIVE = $(DOWNLOADS)/mingw-w64-gcc-mcf.7z
URL = https://gcc-mcf.lhmouse.com/mingw-w64-gcc-mcf_20210307_10.2.1_x64_da2986968645281628457a1a9b7e349da571f488.7z

dist: $(DIST)/mcfgthread-12.dll
build: $(MCF)

$(MCF): $(UNARCHIVED)
	-rm $(MCF)
	ln -s $(UNARCHIVED) $(MCF)

$(UNARCHIVED): $(ARCHIVE)
	-rm -r $@
	cd $(DOWNLOADS) && p7zip -d -k $(notdir $<)
	touch $@

$(ARCHIVE):
	wget '$(URL)' -O $(addsuffix .tmp,$@)
	mv $(addsuffix .tmp,$@) $@

$(DIST)/mcfgthread-12.dll: $(MCF)
	cp $(MCF)/bin/mcfgthread-12.dll $@

clean:
distclean:
	rm -r $(UNARCHIVED) $(ARCHIVE)
