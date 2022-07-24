include Prelude.mk

PACKAGES = $(patsubst %.mk,%,$(filter-out Prelude.mk,$(notdir $(wildcard $(SRC)/*.mk))))

all:
	+$(SELF_MAKE) prepare
	+$(SELF_MAKE) build

prepare:
	mkdir -p $(BIN) $(INCLUDE) $(LIB) $(PKGCFG)

build: $(PACKAGES)

$(PACKAGES):
	PKG_CONFIG_LIBDIR=$(PKG_CONFIG_LIBDIR) $(MAKE) -f $(SRC)/$@.mk

libass: freetype harfbuzz fribidi
mpv: libass ffmpeg lua

PKG_CLEAN = $(addprefix clean-,$(PACKAGES))

clean: $(PKG_CLEAN)

$(PKG_CLEAN):
	$(MAKE) -f $(SRC)/$(patsubst clean-%,%,$@).mk clean

PKG_DISTCLEAN = $(addprefix distclean-,$(PACKAGES))

distclean: $(PKG_DISTCLEAN)

$(PKG_DISTCLEAN):
	$(MAKE) -f $(SRC)/$(patsubst distclean-%,%,$@).mk distclean

.PHONY: all prepare build $(PACKAGES) clean $(PKG_CLEAN) distclean $(PKG_DISTCLEAN)
