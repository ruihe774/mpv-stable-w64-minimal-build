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

HOST = x86_64-w64-mingw32
STRIP = $(HOST)-strip -s
PKG_CONFIG_LIBDIR=/usr/$(HOST)/lib/pkgconfig:$(PKGCFG)

PKG_MK = $(notdir $(lastword $(subst $(lastword $(MAKEFILE_LIST)),,$(MAKEFILE_LIST))))
PKG_NAME = $(if $(subst Makefile,,$(PKG_MK)),$(basename $(PKG_MK)),toplevel)
PKG_SRC = $(SRC)/$(PKG_NAME)
PKG_FILES = $(SRC)/$(PKG_NAME).files
PKG_BUILD = $(CWD)/$(PKG_NAME).build

SELF_MAKE = $(MAKE) -f $(SRC)/$(PKG_MK)
SUB_MAKE = $(MAKE) -C $(PKG_SRC)
SUB_NINJA = ninja -C $(PKG_BUILD)

MESON_CROSS = $(SRC)/meson_cross.txt
CMAKE_TOOLCHAIN = $(SRC)/toolchain.cmake

SUB_CONFIGURE = cd $(PKG_SRC) && ./configure --host=$(HOST) --prefix=$(PREFIX) CFLAGS="-flto -O3" CXXFLAGS="-flto -O3"
SUB_MESON = meson --prefix=$(PREFIX) --buildtype=release -Dc_args=-I$(INCLUDE) -Dc_link_args=-L$(LIB) -Dcpp_args=-I$(INCLUDE) -Dcpp_link_args=-L$(LIB) -Dcpp_rtti=false -Db_lto=true --cross-file=$(MESON_CROSS) $(MESON_OPTIONS) $(PKG_BUILD) $(PKG_SRC)
SUB_CMAKE = cmake -H$(PKG_SRC) -B$(PKG_BUILD) -GNinja -DCMAKE_INSTALL_PREFIX=$(PREFIX) -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=$(CMAKE_TOOLCHAIN) $(CMAKE_OPTIONS)

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
ifndef NO_DIST
.PHONY: dist
endif

ifdef DLL_NAME

BIN_DLL = $(BIN)/$(DLL_NAME)
DIST_DLL = $(DIST)/$(DLL_NAME)

dist: $(DIST_DLL)

$(DIST_DLL): $(BIN_DLL)
	$(STRIP) $(BIN_DLL) -o $(DIST_DLL)

build: $(BIN_DLL)

endif

ifdef HAVE_PRECONFIG_HOOK
.PHONY: preconfig-hook
endif
ifdef HAVE_POSTCONFIG_HOOK
.PHONY: postconfig-hook
endif

ifdef MESON_OPTIONS

ifdef DLL_NAME

$(BIN_DLL): $(PKG_BUILD) FORCE
	$(SUB_NINJA)
	$(SUB_NINJA) install

endif

$(PKG_BUILD):
  ifdef HAVE_PRECONFIG_HOOK
	+$(SELF_MAKE) preconfig-hook
  endif
	$(SUB_MESON)
  ifdef HAVE_POSTCONFIG_HOOK
	+$(SELF_MAKE) postconfig-hook
  endif

clean:
	$(SUB_NINJA) clean
distclean:
	-rm -rf $(PKG_BUILD)

endif

ifdef CMAKE_OPTIONS

ifdef DLL_NAME

$(BIN_DLL): $(PKG_BUILD) FORCE
	$(SUB_NINJA)
	$(SUB_NINJA) install

endif

$(PKG_BUILD):
  ifdef HAVE_PRECONFIG_HOOK
	+$(SELF_MAKE) preconfig-hook
  endif
	$(SUB_CMAKE)
  ifdef HAVE_POSTCONFIG_HOOK
	+$(SELF_MAKE) postconfig-hook
  endif

clean:
	$(SUB_NINJA) clean
distclean:
	-rm -rf $(PKG_BUILD)

endif

ifdef COPYFROM_PATH
dist: $(DIST)/$(notdir $(COPYFROM_PATH))
$(DIST)/$(notdir $(COPYFROM_PATH)):
	$(STRIP) $(COPYFROM_PATH) -o $@
build:
clean:
distclean:
endif

endif
