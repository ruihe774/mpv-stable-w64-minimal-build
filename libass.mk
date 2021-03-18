include Prelude.mk

SUB_MAKE = $(MAKE) -C libass
SELF_MAKE = $(MAKE) -f libass.mk

build:
	$(SELF_MAKE) patch
	$(SELF_MAKE) dist/libass-9.dll

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

patch:
	cd libass && git checkout -- . && git apply ../libass.files/*.patch

.PHONY: build clean distclean patch
