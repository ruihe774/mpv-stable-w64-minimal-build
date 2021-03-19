include Prelude.mk

SELF_MAKE = $(MAKE) -f harfbuzz.mk
SUB_NINJA = ninja -C harfbuzz/build

build:
	$(SELF_MAKE) patch
	$(SELF_MAKE) dist/libharfbuzz-0.dll

dist/libharfbuzz-0.dll: buildroot/bin/libharfbuzz-0.dll
	$(STRIP) $< -o $@

buildroot/bin/libharfbuzz-0.dll: harfbuzz/build
	$(SUB_NINJA)
	$(SUB_NINJA) install

harfbuzz/build:
	cd harfbuzz && meson --prefix=$(PREFIX) --cross-file=../harfbuzz.files/meson_cross.txt --buildtype=minsize -Dtests=disabled '-Dcpp_args=-DHB_TINY -DHB_NO_OT_FONT' build .

clean:
	$(SUB_NINJA) clean

distclean:
	rm -rf harfbuzz/build

patch:
	cd harfbuzz && git checkout -- . && git apply ../harfbuzz.files/*.patch

.PHONY: build clean distclean patch
