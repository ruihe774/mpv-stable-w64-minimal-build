DLL_NAME = libfreetype.6.dylib
MESON_OPTIONS =\
--buildtype=release\
-Dzlib=disabled\
-Dbzip2=disabled\
-Dpng=disabled\
-Dharfbuzz=disabled\
-Dbrotli=disabled\
'-Dc_args=-DFT_CONFIG_MODULES_H=<ftmodule.h>'
HAVE_PRECONFIG_HOOK = 1
HAVE_POSTCONFIG_HOOK = 1

include Prelude.mk

preconfig-hook:
	cp $(PKG_FILES)/modules.cfg $(PKG_SRC)
postconfig-hook:
	cp $(PKG_FILES)/ftoption.h $(PKG_BUILD)
