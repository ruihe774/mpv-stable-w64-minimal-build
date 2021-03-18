build: dist/iconv.dll

dist/iconv.dll:
	cp /usr/x86_64-w64-mingw32/bin/iconv.dll $@

clean:
distclean:

.PHONY: build clean distclean
