DLL_NAME = liblua52.dylib

include Prelude.mk

LUA_MAKE = $(SUB_MAKE) INSTALL_TOP=$(PREFIX) TO_BIN=liblua52.dylib

UNARCHIVED = $(DOWNLOADS)/lua-5.2.4
ARCHIVE = $(DOWNLOADS)/lua-5.2.4.tar.gz
URL = https://www.lua.org/ftp/lua-5.2.4.tar.gz

$(BIN_DLL): $(PKG_SRC)
	+$(LUA_MAKE) mingw
	cd $(PKG_SRC)/src && cc -shared -o liblua52.dylib lapi.o lcode.o lctype.o ldebug.o ldo.o ldump.o lfunc.o lgc.o llex.o lmem.o lobject.o lopcodes.o lparser.o lstate.o lstring.o ltable.o ltm.o lundump.o lvm.o lzio.o lauxlib.o lbaselib.o lbitlib.o lcorolib.o ldblib.o liolib.o lmathlib.o loslib.o lstrlib.o ltablib.o loadlib.o linit.o	# fuck!
	+$(LUA_MAKE) install
	cp $(PKG_FILES)/lua.pc $(PKGCFG)

$(PKG_SRC): $(UNARCHIVED)
	cp -rT $< $@

$(UNARCHIVED): $(ARCHIVE)
	-rm -r $@
	cd $(DOWNLOADS) && tar -xf $(notdir $<) $(notdir $@)
	touch $@

$(ARCHIVE):
	curl -fsSL '$(URL)' -o $(addsuffix .tmp,$@)
	mv $(addsuffix .tmp,$@) $@

clean:
	+$(LUA_MAKE) clean

distclean:
	rm -r $(UNARCHIVED) $(ARCHIVE) $(PKG_SRC)
