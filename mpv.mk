include Prelude.mk

$(DIST): $(DIST)/mpv.exe $(DIST)/mpv.com

$(DIST)/mpv.exe: $(PKG_SRC)/build/mpv.exe
	$(STRIP) $< -o $@

$(DIST)/mpv.com: $(PKG_SRC)/build/mpv.com
	$(STRIP) $< -o $@

$(PKG_SRC)/build/mpv.exe $(PKG_SRC)/build/mpv.com &: $(PKG_SRC)/build/config.h
	cd $(PKG_SRC) && ./waf

$(PKG_SRC)/build/config.h: $(PKG_SRC)/waf
	cd $(PKG_SRC) && PKG_CONFIG=pkg-config TARGET=$(HOST) DEST_OS=win32 ./waf configure --disable-debug-build

$(PKG_SRC)/waf:
	cd $(PKG_SRC) && ./bootstrap.py

clean:
	cd $(PKG_SRC) && ./waf clean

distclean:
	cd $(PKG_SRC) && ./waf distclean
