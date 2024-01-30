DLL_NAME = lua52.dll

include Prelude.mk

LUA_MAKE = $(SUB_MAKE) INSTALL_TOP=$(PREFIX) CC=$(HOST)-gcc-posix TO_BIN=lua52.dll TO_LIB=liblua.dll.a CFLAGS="-flto -O3"

UNARCHIVED = $(DOWNLOADS)/lua-5.2.4
ARCHIVE = $(DOWNLOADS)/lua-5.2.4.tar.gz
URL = https://www.lua.org/ftp/lua-5.2.4.tar.gz

$(BIN_DLL): $(PKG_SRC)
	+$(LUA_MAKE) mingw
	cd $(PKG_SRC)/src && $(HOST)-gcc-posix -Wl,--out-implib=liblua.dll.a -shared -flto -O3 -o lua52.dll lapi.o lcode.o lctype.o ldebug.o ldo.o ldump.o lfunc.o lgc.o llex.o lmem.o lobject.o lopcodes.o lparser.o lstate.o lstring.o ltable.o ltm.o lundump.o lvm.o lzio.o lauxlib.o lbaselib.o lbitlib.o lcorolib.o ldblib.o liolib.o lmathlib.o loslib.o lstrlib.o ltablib.o loadlib.o linit.o	# fuck!
	+$(LUA_MAKE) install
	cp $(PKG_FILES)/lua.pc $(PKGCFG)

$(PKG_SRC): $(UNARCHIVED)
	cp -rT $< $@

$(UNARCHIVED): $(ARCHIVE)
	-rm -r $@
	cd $(DOWNLOADS) && tar -xf $(notdir $<) $(notdir $@)
	touch $@

$(ARCHIVE):
	wget '$(URL)' -O $(addsuffix .tmp,$@)
	mv $(addsuffix .tmp,$@) $@

clean:
	+$(LUA_MAKE) clean

distclean:
	-rm -r $(UNARCHIVED) $(ARCHIVE) $(PKG_SRC)
