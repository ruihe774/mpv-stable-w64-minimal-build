include Prelude.mk

PACKAGES = freetype fribidi harfbuzz libass ffmpeg mpv

all:
	$(MAKE) prepare
	$(MAKE) build

prepare:
	mkdir -p downloads
	mkdir -p buildroot/bin buildroot/include buildroot/lib/pkgconfig buildroot/share
	mkdir -p dist

build: $(PACKAGES)

apt-install:
	apt install build-essential g++-mingw-w64-x86-64 mingw-w64-x86-64-dev win-iconv-mingw-w64-dev libz-mingw-w64-dev pkg-config autoconf automake libtool p7zip wget --no-install-recommends

$(PACKAGES):
	env PKG_CONFIG_LIBDIR=/usr/x86_64-w64-mingw32/lib/pkgconfig:$(PREFIX)/lib/pkgconfig $(MAKE) -f $@.mk

harfbuzz: freetype
libass: freetype harfbuzz fribidi
mpv: libass ffmpeg

PKG_CLEAN = $(addprefix clean-, $(PACKAGES))

clean: $(PKG_CLEAN)

$(PKG_CLEAN):
	$(MAKE) -f $(subst clean-,,$@).mk clean

PKG_DISTCLEAN = $(addprefix distclean-, $(PACKAGES))

distclean: $(PKG_DISTCLEAN)

$(PKG_DISTCLEAN):
	$(MAKE) -f $(subst distclean-,,$@).mk distclean

pack:
	-rm dist*.7z
	cd dist && 7zr a ../dist.7z *
	mv dist.7z "dist [`7zr h dist.7z|grep 'CRC32  for data'|tail -c 9`].7z"

.PHONY: all prepare build apt-install $(PACKAGES) clean $(PKG_CLEAN) distclean $(PKG_DISTCLEAN) pack
