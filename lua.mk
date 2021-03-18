include Prelude.mk

SUB_MAKE = $(MAKE) -C lua INSTALL_TOP=$(PREFIX) CC=x86_64-w64-mingw32-gcc TO_BIN=lua52.dll TO_LIB=liblua.dll.a
DOWNLOADS = downloads
UNARCHIVED = $(DOWNLOADS)/lua-5.2.4
ARCHIVE = $(DOWNLOADS)/lua-5.2.4.tar.gz
URL = https://www.lua.org/ftp/lua-5.2.4.tar.gz

build: dist/lua52.dll buildroot/lib/pkgconfig/lua.pc

dist/lua52.dll: buildroot/bin/lua52.dll
	$(STRIP) $< -o $@

buildroot/bin/lua52.dll: lua
	$(SUB_MAKE) mingw
	cd lua/src && x86_64-w64-mingw32-gcc -Wl,--out-implib=liblua.dll.a -shared -o lua52.dll lapi.o lcode.o lctype.o ldebug.o ldo.o ldump.o lfunc.o lgc.o llex.o lmem.o lobject.o lopcodes.o lparser.o lstate.o lstring.o ltable.o ltm.o lundump.o lvm.o lzio.o lauxlib.o lbaselib.o lbitlib.o lcorolib.o ldblib.o liolib.o lmathlib.o loslib.o lstrlib.o ltablib.o loadlib.o linit.o	# fuck!
	$(SUB_MAKE) install

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
