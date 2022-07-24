SHELL = /bin/bash

SRC = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
CWD = $(abspath .)
PREFIX = $(CWD)/buildroot
BIN = $(PREFIX)/bin
INCLUDE = $(PREFIX)/include
LIB = $(PREFIX)/lib
PKGCFG = $(LIB)/pkgconfig

PKG_CONFIG_LIBDIR=$(PKGCFG)

_pkg_mk_idx = $(shell expr $(words $(MAKEFILE_LIST)) - 1)
PKG_MK = $(notdir $(word $(_pkg_mk_idx),$(MAKEFILE_LIST)))
PKG_NAME = $(if $(subst Makefile,,$(PKG_MK)),$(basename $(PKG_MK)),toplevel)
PKG_SRC = $(SRC)/$(PKG_NAME)
PKG_FILES = $(SRC)/$(PKG_NAME).files
PKG_BUILD = $(CWD)/$(PKG_NAME).build

SELF_MAKE = make -f $(SRC)/$(PKG_MK)
SUB_MAKE = make -C $(PKG_SRC)
SUB_NINJA = ninja -C $(PKG_BUILD)
SUB_CONFIGURE = cd $(PKG_SRC) && ./configure --prefix=$(PREFIX)

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

FORCE:
.PHONY: all build clean distclean FORCE

ifdef DLL_NAME
BIN_DLL = $(LIB)/$(DLL_NAME)
endif

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
	meson --prefix=$(PREFIX) $(MESON_OPTIONS) $(PKG_BUILD) $(PKG_SRC)
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
