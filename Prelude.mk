SHELL = /bin/bash

SRC = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
CWD = $(abspath .)
PREFIX = $(CWD)/buildroot
BIN = $(PREFIX)/bin
INCLUDE = $(PREFIX)/include
LIB = $(PREFIX)/lib
PKGCFG = $(LIB)/pkgconfig
DIST = $(CWD)/dist
DOWNLOADS = $(CWD)/downloads
MCF = $(CWD)/mingw-w64-mcf

HOST = x86_64-w64-mingw32
PKG_CONFIG_LIBDIR=/usr/$(HOST)/lib/pkgconfig:$(PKGCFG)

_pkg_mk_idx != expr $(words $(MAKEFILE_LIST)) - 1
PKG_MK = $(notdir $(word $(_pkg_mk_idx),$(MAKEFILE_LIST)))
PKG_NAME = $(if $(subst Makefile,,$(PKG_MK)),$(basename $(PKG_MK)),toplevel)
PKG_SRC = $(SRC)/$(PKG_NAME)
PKG_FILES = $(SRC)/$(PKG_NAME).files
PKG_BUILD = $(CWD)/$(PKG_NAME).build

SELF_MAKE = make -f $(SRC)/$(PKG_MK)
SUB_MAKE = make -C $(PKG_SRC)
SUB_NINJA = ninja -C $(PKG_BUILD)
SUB_CONFIGURE = cd $(PKG_SRC) && ./configure --host=$(HOST) --prefix=$(PREFIX)

.DEFAULT_GOAL = all

ifneq ($(PKG_NAME),toplevel)

ifneq ($(wildcard $(PKG_FILES)/*.patch),)
PATCH_RECORD = $(SRC)/.$(PKG_NAME).patched
$(PATCH_RECORD):
	cd $(PKG_SRC) && git checkout -- . && git apply $(PKG_FILES)/*.patch
	touch $@
patch: $(PATCH_RECORD)
.PHONY: patch
endif

all:
  ifdef PATCH_RECORD
	+$(SELF_MAKE) patch
  endif
	+$(SELF_MAKE) build
  ifndef NO_DIST
	+$(SELF_MAKE) dist
  endif

FORCE:
.PHONY: all build clean distclean FORCE

ifdef DLL_NAME
BIN_DLL = $(BIN)/$(DLL_NAME)
DIST_DLL = $(DIST)/$(DLL_NAME)
endif

STRIP = $(HOST)-strip -s
ifdef DLL_NAME
dist: $(DIST_DLL)
$(DIST_DLL): $(BIN_DLL)
	$(STRIP) $(BIN_DLL) -o $(DIST_DLL)
.PHONY: dist
endif

MESON_CROSS = $(SRC)/meson_cross.txt

ifdef DLL_NAME

build: $(BIN_DLL)
ifdef HAVE_PRECONFIG_HOOK
.PHONY: preconfig-hook
endif
ifdef HAVE_POSTCONFIG_HOOK
.PHONY: postconfig-hook
endif

ifdef MESON_OPTIONS

$(BIN_DLL): $(PKG_BUILD) FORCE
	$(SUB_NINJA)
	$(SUB_NINJA) install

$(PKG_BUILD):
  ifdef HAVE_PRECONFIG_HOOK
	+$(SELF_MAKE) preconfig-hook
  endif
	meson --prefix=$(PREFIX) --cross-file=$(MESON_CROSS) $(MESON_OPTIONS) $(PKG_BUILD) $(PKG_SRC)
  ifdef HAVE_POSTCONFIG_HOOK
	+$(SELF_MAKE) postconfig-hook
  endif

clean:
	$(SUB_NINJA) clean
distclean:
	rm -rf $(PKG_BUILD)

endif

endif

endif
