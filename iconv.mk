ICONV_PATH = /usr/x86_64-w64-mingw32/bin/iconv.dll

dist: $(DIST)/iconv.dll:
$(DIST)/iconv.dll:
	cp $(ICONV_PATH) $@

build:
clean:
distclean:
