DLL_NAME = libshaderc_shared.dll

include Prelude.mk

$(BIN_DLL): $(PKG_BUILD) FORCE
	$(SUB_NINJA)
	cp $(PKG_BUILD)/libshaderc/libshaderc_shared.dll $(BIN_DLL)
	cp $(PKG_BUILD)/libshaderc/libshaderc_shared.dll.a $(LIB)
	cp -r $(PKG_SRC)/libshaderc/include/shaderc $(INCLUDE)
	cp -r $(PKG_SRC)/libshaderc_util/include/libshaderc_util $(INCLUDE)
	cp $(PKG_FILES)/shaderc.pc $(PKGCFG)

$(PKG_BUILD): $(PKG_SRC)
	$(SUB_CMAKE)\
		-DSHADERC_SKIP_TESTS=ON\
		-DSHADERC_SKIP_EXAMPLES=ON\
		-DDISABLE_EXCEPTIONS=ON

$(PKG_SRC):
	cd $(SRC)/shaderc.good && ./update_shaderc_sources.py
	-rm -r $@
	ln -s $(SRC)/shaderc.good/src $@

clean:
	$(SUB_NINJA) clean

distclean:
	-rm -rf $(PKG_BUILD)
