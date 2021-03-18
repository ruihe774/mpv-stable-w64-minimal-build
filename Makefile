include Prelude.mk

PACKAGES = freetype

all:
	$(MAKE) prepare
	$(MAKE) build

prepare:
	mkdir -p downloads
	mkdir -p buildroot/bin buildroot/include buildroot/lib/pkgconfig buildroot/share
	mkdir -p dist

build: $(PACKAGES)

apt-install:
	apt install build-essential g++-mingw-w64-x86-64 mingw-w64-x86-64-dev win-iconv-mingw-w64-dev libz-mingw-w64-dev pkg-config autoconf automake libtool unar --no-install-recommends

$(PACKAGES):
	env PKG_CONFIG_LIBDIR=/usr/x86_64-w64-mingw32/lib/pkgconfig:$(PREFIX)/lib/pkgconfig $(MAKE) -f $@.mk

PKG_CLEAN = $(addprefix clean_, $(PACKAGES))

clean: $(PKG_CLEAN)

$(PKG_CLEAN):
	$(MAKE) -f $(subst clean_,,$@).mk clean

PKG_DISTCLEAN = $(addprefix distclean_, $(PACKAGES))

distclean: $(PKG_DISTCLEAN)

$(PKG_DISTCLEAN):
	$(MAKE) -f $(subst distclean_,,$@).mk distclean

.PHONY: all prepare build apt-install $(PACKAGES) clean $(PKG_CLEAN) distclean $(PKG_DISTCLEAN)
