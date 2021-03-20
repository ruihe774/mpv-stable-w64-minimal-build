include Prelude.mk

PACKAGES = $(patsubst %.mk,%,$(filter-out Prelude.mk,$(notdir $(wildcard $(SRC)/*.mk))))

all:
	+$(SELF_MAKE) prepare
	+$(SELF_MAKE) build

prepare:
	mkdir -p $(DOWNLOADS)
	mkdir -p $(BIN) $(INCLUDE) $(LIB) $(PKGCFG)
	mkdir -p $(DIST)

build: $(PACKAGES)

apt-install:
	apt install build-essential g++-mingw-w64-x86-64 mingw-w64-x86-64-dev win-iconv-mingw-w64-dev libz-mingw-w64-dev pkg-config autoconf automake libtool python3-pip p7zip wget ninja-build --no-install-recommends
	pip3 install meson --system

$(PACKAGES):
	PKG_CONFIG_LIBDIR=$(PKG_CONFIG_LIBDIR) $(MAKE) -f $(SRC)/$@.mk

libass: freetype harfbuzz fribidi
mpv: libass ffmpeg lua ffnvcodec

PKG_CLEAN = $(addprefix clean-,$(PACKAGES))

clean: $(PKG_CLEAN)

$(PKG_CLEAN):
	$(MAKE) -f $(SRC)/$(patsubst clean-%,%,$@).mk clean

PKG_DISTCLEAN = $(addprefix distclean-,$(PACKAGES))

distclean: $(PKG_DISTCLEAN)

$(PKG_DISTCLEAN):
	$(MAKE) -f $(SRC)/$(patsubst distclean-%,%,$@).mk distclean

pack:
	-rm dist*.7z
	cd dist && 7zr a ../dist.7z *
	mv dist.7z "dist [`7zr h dist.7z|grep 'CRC32  for data'|tail -c 9`].7z"

.PHONY: all prepare build apt-install $(PACKAGES) clean $(PKG_CLEAN) distclean $(PKG_DISTCLEAN) pack
