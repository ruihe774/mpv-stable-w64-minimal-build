LIBSTDCXX = /usr/lib/gcc/x86_64-w64-mingw32/9.3-win32/libstdc++-6.dll

include Prelude.mk

dist: $(DIST)/libstdc++-6.dll
$(DIST)/libstdc++-6.dll:
	cp $(LIBSTDCXX) $@

build:
clean:
distclean:
