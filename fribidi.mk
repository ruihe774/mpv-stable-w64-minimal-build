DLL_NAME = libfribidi-0.dll

include Prelude.mk

build: $(BIN_DLL)

$(BIN_DLL): $(PKG_SRC)/Makefile FORCE
	+$(SUB_MAKE)
	+$(SUB_MAKE) install

$(PKG_SRC)/Makefile: $(PKG_SRC)/configure
	cd $(PKG_SRC) && ./configure
	+$(SUB_MAKE)
	$(SUB_CONFIGURE)

$(PKG_SRC)/configure:
	cd $(PKG_SRC) && NOCONFIGURE=1 ./autogen.sh

clean:
	+$(SUB_MAKE) clean

distclean:
	+$(SUB_MAKE) distclean
