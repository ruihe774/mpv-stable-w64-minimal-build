DLL_NAME = libfreetype-6.dll
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
	cp freetype.files/modules.cfg freetype
postconfig-hook:
	cp freetype.files/ftoption.h freetype/build
