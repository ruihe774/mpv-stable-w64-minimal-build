include Prelude.mk

SUB_MAKE = $(MAKE) -C harfbuzz

build: dist/libharfbuzz-0.dll

dist/libharfbuzz-0.dll: buildroot/bin/libharfbuzz-0.dll
	$(STRIP) $< -o $@

buildroot/bin/libharfbuzz-0.dll: harfbuzz/Makefile
	cp harfbuzz.files/harfbuzz.def harfbuzz/src/
	-$(SUB_MAKE)
	cp harfbuzz/src/.libs/libharfbuzz-0.dll buildroot/bin/

harfbuzz/Makefile: harfbuzz/configure
	cd harfbuzz && env 'CXXFLAGS=-DHB_TINY -Os' ./configure --host=$(TARGET) --prefix=$(PREFIX) --with-glib=no --with-cairo=no --with-fontconfig=no --with-icu=no --with-freetype=yes

harfbuzz/configure:
	cd harfbuzz && git checkout -- . && git apply ../harfbuzz.files/*.patch
	cd harfbuzz && env NOCONFIGURE=1 ./autogen.sh

clean:
	$(SUB_MAKE) clean

distclean:
	$(SUB_MAKE) distclean

.PHONY: build clean distclean
