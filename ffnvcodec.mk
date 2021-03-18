include Prelude.mk

SUB_MAKE = $(MAKE) -C ffnvcodec

build: buildroot/include/ffnvcodec

buildroot/include/ffnvcodec:
	$(SUB_MAKE) PREFIX=$(PREFIX) install

clean:
distclean:

.PHONY: build clean distclean
