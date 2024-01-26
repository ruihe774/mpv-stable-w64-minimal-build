DLL_NAME = libfreetype-6.dll
MESON_OPTIONS =\
--buildtype=release\
-Dbrotli=disabled\
-Dbzip2=disabled\
-Dharfbuzz=disabled\
-Dmmap=enabled\
-Dpng=disabled\
-Dtests=disabled\
-Dzlib=disabled
HAVE_PRECONFIG_HOOK = 1
HAVE_POSTCONFIG_HOOK = 1

include Prelude.mk

preconfig-hook:
	cp $(PKG_FILES)/modules.cfg $(PKG_SRC)
postconfig-hook:
	cp $(PKG_FILES)/ftoption.h $(PKG_BUILD)
