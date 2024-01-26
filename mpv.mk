MESON_OPTIONS =\
--buildtype=release\

include Prelude.mk

dist: $(DIST)/mpv.exe $(DIST)/mpv.com
build: $(PKG_BUILD)/mpv.exe $(PKG_BUILD)/generated/mpv.com

$(DIST)/mpv.exe: $(PKG_BUILD)/mpv.exe
	$(STRIP) $< -o $@

$(DIST)/mpv.com: $(PKG_BUILD)/generated/mpv.com
	$(STRIP) $< -o $@

$(PKG_BUILD)/mpv.exe $(PKG_BUILD)/generated/mpv.com &: $(PKG_BUILD)
	$(SUB_NINJA)
