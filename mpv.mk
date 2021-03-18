include Prelude.mk

build: dist/mpv.exe dist/mpv.com

dist/mpv.exe: mpv/build/mpv.exe
	$(STRIP) $< -o $@

dist/mpv.com: mpv/build/mpv.com
	$(STRIP) $< -o $@

mpv/build/mpv.com: mpv/build/mpv.exe

mpv/build/mpv.exe: mpv/build/config.h
	cd mpv && ./waf

mpv/build/config.h: mpv/waf
	cd mpv && env PKG_CONFIG=pkg-config TARGET=x86_64-w64-mingw32 DEST_OS=win32 ./waf configure --disable-debug-build

mpv/waf:
	cd mpv && ./bootstrap.py

clean:
	cd mpv && ./waf clean

distclean:
	cd mpv && ./waf distclean

.PHONY: build clean distclean
