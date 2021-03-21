DLL_NAME = libshaderc_shared.dll

include Prelude.mk

$(BIN_DLL): $(PKG_BUILD)
	$(SUB_NINJA)
	cp $(PKG_BUILD)/libshaderc/libshaderc_shared.dll $(BIN_DLL)
	cp $(PKG_BUILD)/libshaderc/libshaderc_shared.dll.a $(LIB)
	cp -r $(PKG_SRC)/libshaderc/include/shaderc $(INCLUDE)
	cp -r $(PKG_SRC)/libshaderc_util/include/libshaderc_util $(INCLUDE)
	cp $(PKG_FILES)/shaderc.pc $(PKGCFG)

$(PKG_BUILD): $(PKG_SRC) $(MCF)/$(HOST)-gcc-mcf $(MCF)/$(HOST)-g++-mcf
	PATH=$(MCF):$$PATH cmake -H$(PKG_SRC) -B$(PKG_BUILD) -GNinja\
		-DCMAKE_BUILD_TYPE=Release\
		-DSHADERC_SKIP_TESTS=ON\
		-DSHADERC_SKIP_SPVC=ON\
		-DCMAKE_TOOLCHAIN_FILE=$(PKG_FILES)/toolchain.cmake


$(MCF)/$(HOST)-gcc-mcf $(MCF)/$(HOST)-g++-mcf:
	echo 'WINEPATH=$(MCF)/bin wine $(addsuffix .exe,$(patsubst %-mcf,%,$(notdir $@))) "$$@"' > $@
	chmod +x $@

$(PKG_SRC):
	cd $(SRC)/shaderc.good && ./update_shaderc_sources.py
	ln -s $(SRC)/shaderc.good/src $@

clean:
	$(SUB_NINJA) clean

distclean:
	rm -rf $(PKG_BUILD)
