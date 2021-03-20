NO_DIST = 1

include Prelude.mk

build: $(INCLUDE)/ffnvcodec

$(INCLUDE)/ffnvcodec:
	+$(SUB_MAKE) PREFIX=$(PREFIX) install

clean:
distclean:
