DLL_NAME = libplacebo-342.dll
MESON_OPTIONS =\
-Ddemos=false\
-Ddovi=disabled

HAVE_POSTCONFIG_HOOK = 1

include Prelude.mk

postconfig-hook:
	cp -r $(PKG_SRC)/3rdparty/Vulkan-Headers/include/* $(INCLUDE)
