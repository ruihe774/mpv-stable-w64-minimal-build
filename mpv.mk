include Prelude.mk

dist: $(DIST)/mpv
build: $(PKG_SRC)/build/mpv

$(DIST)/mpv: $(PKG_SRC)/build/mpv
	$(STRIP) $< -o $@

$(PKG_SRC)/build/mpv: $(PKG_SRC)/build/config.h
	cd $(PKG_SRC) && ./waf

$(PKG_SRC)/build/config.h: $(PKG_SRC)/waf
	cd $(PKG_SRC) && PKG_CONFIG=pkg-config ./waf configure --disable-debug-build

$(PKG_SRC)/waf:
	cd $(PKG_SRC) && ./bootstrap.py

clean:
	cd $(PKG_SRC) && ./waf clean

distclean:
	cd $(PKG_SRC) && ./waf distclean
