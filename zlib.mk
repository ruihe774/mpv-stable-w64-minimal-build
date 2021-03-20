ZLIB_PATH = /usr/x86_64-w64-mingw32/lib/zlib1.dll

include Prelude.mk

dist: $(DIST)/zlib1.dll
$(DIST)/zlib1.dll:
	cp $(ZLIB_PATH) $@

build:
clean:
distclean:
