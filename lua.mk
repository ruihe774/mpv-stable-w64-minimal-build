include Prelude.mk

SUB_MAKE = $(MAKE) -C lua
DOWNLOADS = downloads
UNARCHIVED = $(DOWNLOADS)/lua-5.2.4
ARCHIVE = $(DOWNLOADS)/lua-5.2.4.tar.gz
URL = https://www.lua.org/ftp/lua-5.2.4.tar.gz

build: dist/lua52.dll buildroot/lib/pkgconfig/lua.pc

dist/lua52.dll: buildroot/bin/lua52.dll
	$(STRIP) $< -o $@

buildroot/bin/lua52.dll: lua
	$(SUB_MAKE) INSTALL_TOP=$(PREFIX) CC=x86_64-w64-mingw32-gcc TO_BIN=lua52.dll mingw
	$(SUB_MAKE) INSTALL_TOP=$(PREFIX) CC=x86_64-w64-mingw32-gcc TO_BIN=lua52.dll install

buildroot/lib/pkgconfig/lua.pc:
	cp lua.files/lua.pc $@

lua: $(UNARCHIVED)
	cp -rT $(UNARCHIVED) lua

$(UNARCHIVED): $(ARCHIVE)
	cd downloads && tar -xf $(notdir $(ARCHIVE)) $(notdir $(UNARCHIVED))
	touch $@

$(ARCHIVE):
	wget '$(URL)' -O $(ARCHIVE)

clean:
	$(SUB_MAKE) clean

distclean:
	rm -r $(UNARCHIVED) $(ARCHIVE) lua

.PHONY: build clean distclean
