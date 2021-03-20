ZLIB_PATH = /usr/x86_64-w64-mingw32/lib/zlib1.dll

dist: $(DIST)/iconv.dll:
$(DIST)/iconv.dll:
	cp $(ZLIB_PATH) $@

build:
clean:
distclean:
