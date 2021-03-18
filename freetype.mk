include Prelude.mk

SUB_MAKE = $(MAKE) -C freetype

build: dist/libfreetype-6.dll

dist/libfreetype-6.dll: buildroot/bin/libfreetype-6.dll
	$(STRIP) $< -o $@

buildroot/bin/libfreetype-6.dll: freetype/config.mk
	$(SUB_MAKE)
	$(SUB_MAKE) install

freetype/config.mk: freetype/configure
	cd freetype && ./autogen.sh
	cd freetype && ./configure --host=$(TARGET) --prefix=$(PREFIX) --with-zlib=yes --with-bzip2=no --with-png=no --with-harfbuzz=no --with-brotli=no

clean:
	$(SUB_MAKE) clean

distclean:
	$(SUB_MAKE) distclean

.PHONY: build clean distclean
