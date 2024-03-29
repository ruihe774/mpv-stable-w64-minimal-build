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
	apt install build-essential g++-mingw-w64-x86-64 mingw-w64-x86-64-dev win-iconv-mingw-w64-dev libz-mingw-w64-dev pkg-config autoconf automake libtool p7zip wget ninja-build cmake nasm python-is-python3 python3-pip zstd --no-install-recommends
	pip3 install meson

$(PACKAGES):
	PKG_CONFIG_LIBDIR=$(PKG_CONFIG_LIBDIR) $(MAKE) -f $(SRC)/$@.mk

libass: freetype harfbuzz fribidi
mpv: libass ffmpeg lua shaderc spirv-cross libplacebo
libplacebo: shaderc spirv-cross vulkan-loader

PKG_CLEAN = $(addprefix clean-,$(PACKAGES))

clean: $(PKG_CLEAN)

$(PKG_CLEAN):
	$(MAKE) -f $(SRC)/$(patsubst clean-%,%,$@).mk clean

PKG_DISTCLEAN = $(addprefix distclean-,$(PACKAGES))

distclean: $(PKG_DISTCLEAN)

$(PKG_DISTCLEAN):
	$(MAKE) -f $(SRC)/$(patsubst distclean-%,%,$@).mk distclean

.PHONY: all prepare build apt-install $(PACKAGES) clean $(PKG_CLEAN) distclean $(PKG_DISTCLEAN)
