include Prelude.mk

SELF_MAKE = $(MAKE) -f freetype.mk
SUB_NINJA = ninja -C freetype/build

build:
	$(SELF_MAKE) patch
	$(SELF_MAKE) dist/libfreetype-6.dll

dist/libfreetype-6.dll: buildroot/bin/libfreetype-6.dll
	$(STRIP) $< -o $@

buildroot/bin/libfreetype-6.dll: freetype/build
	$(SUB_NINJA)
	$(SUB_NINJA) install

freetype/build:
	cp freetype.files/modules.cfg freetype
	cd freetype && meson --prefix=$(PREFIX) --cross-file=../meson_cross.txt --buildtype=release -Dzlib=disabled -Dbzip2=disabled -Dpng=disabled -Dharfbuzz=disabled -Dbrotli=disabled -Dmmap=disabled '-Dc_args=-DFT_CONFIG_MODULES_H=<ftmodule.h>' build .
	cp freetype.files/ftoption.h freetype/build

clean:
	$(SUB_NINJA) clean

distclean:
	rm -rf freetype/build

patch:
	cd freetype && git checkout -- . && git apply ../freetype.files/*.patch

.PHONY: build clean distclean patch
