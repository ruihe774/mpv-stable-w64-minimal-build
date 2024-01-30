MESON_OPTIONS =\
-Dcplugins=disabled

include Prelude.mk

dist: $(DIST)/mpv.exe $(DIST)/mpv.com
build: $(PKG_BUILD)/mpv.exe $(PKG_BUILD)/player/mpv.com

$(DIST)/mpv.exe: $(PKG_BUILD)/mpv.exe
	$(STRIP) $< -o $@

$(DIST)/mpv.com: $(PKG_BUILD)/player/mpv.com
	$(STRIP) $< -o $@

$(PKG_BUILD)/mpv.exe $(PKG_BUILD)/player/mpv.com &: $(PKG_BUILD)
	$(SUB_NINJA)
