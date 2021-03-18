include Prelude.mk

SUB_MAKE = $(MAKE) -C libass

build: dist/libass-9.dll

dist/libass-9.dll: buildroot/bin/libass-9.dll
	$(STRIP) $< -o $@

buildroot/bin/libass-9.dll: libass/Makefile
	$(SUB_MAKE)
	$(SUB_MAKE) install

libass/Makefile: libass/configure
	cd libass && ./configure --host=$(TARGET) --prefix=$(PREFIX) --disable-fontconfig --enable-directwrite

libass/configure:
	cd libass && ./autogen.sh

clean:
	$(SUB_MAKE) clean

distclean:
	$(SUB_MAKE) distclean

.PHONY: build clean distclean
