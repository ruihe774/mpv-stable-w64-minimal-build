build: dist/zlib1.dll

dist/zlib1.dll:
	cp /usr/x86_64-w64-mingw32/lib/zlib1.dll $@

clean:
distclean:

.PHONY: build clean distclean
