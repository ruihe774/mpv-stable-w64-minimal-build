include Prelude.mk

SUB_MAKE = $(MAKE) -C fribidi

build: dist/libfribidi-0.dll

dist/libfribidi-0.dll: buildroot/bin/libfribidi-0.dll
	$(STRIP) $< -o $@

buildroot/bin/libfribidi-0.dll: fribidi/Makefile
	$(SUB_MAKE)
	$(SUB_MAKE) install

fribidi/Makefile: fribidi/configure
	cd fribidi && ./configure
	$(SUB_MAKE)
	cd fribidi && ./configure --host=$(TARGET) --prefix=$(PREFIX)

fribidi/configure:
	cd fribidi && env NOCONFIGURE=1 ./autogen.sh

clean:
	$(SUB_MAKE) clean

distclean:
	$(SUB_MAKE) distclean

.PHONY: build clean distclean
