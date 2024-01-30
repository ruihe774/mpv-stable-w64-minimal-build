NO_DIST = 1

include Prelude.mk

libs = libavformat libavcodec libavutil libavfilter libswresample libswscale
implib = $(addsuffix .dll.a, $(libs))
pc = $(addsuffix .pc, $(libs))
implib_path = $(addprefix $(LIB)/,$(implib))
pc_path = $(addprefix $(PKGCFG)/,$(pc))
header_path = $(addprefix $(INCLUDE)/,$(libs))

build: $(implib_path) $(pc_path) $(header_path)

$(implib_path) $(header_path) $(pc_path) &: $(PKG_SRC)/config.h
	+$(SUB_MAKE)
	+$(SUB_MAKE) install

$(PKG_SRC)/config.h:
	cd $(PKG_SRC) && ./configure --arch=x86_64 --target-os=mingw32 --cross-prefix=$(HOST)- --disable-everything --enable-shared --prefix=$(PREFIX)
