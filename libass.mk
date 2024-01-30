DLL_NAME = libass-9.dll

include Prelude.mk

$(BIN_DLL): $(PKG_SRC)/Makefile
	+$(SUB_MAKE)
	+$(SUB_MAKE) install

$(PKG_SRC)/Makefile: $(PKG_SRC)/configure
	$(SUB_CONFIGURE) --disable-fontconfig --enable-directwrite --disable-static

$(PKG_SRC)/configure:
	cd $(PKG_SRC) && ./autogen.sh

clean:
	-+$(SUB_MAKE) clean

distclean:
	-+$(SUB_MAKE) distclean
