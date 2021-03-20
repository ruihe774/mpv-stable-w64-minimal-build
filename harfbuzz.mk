DLL_NAME = libharfbuzz-0.dll
MESON_OPTIONS =\
--buildtype=minsize\
-Dtests=disabled\
-Ddirectwrite=enabled\
-Dfreetype=disabled\
'-Dcpp_args=\
  -DHB_TINY\
  -DHB_NO_OT_FONT\
  -DHB_NO_OT\
  -DHB_NO_FALLBACK_SHAPE\
  -DHB_NO_UCD\
  -DHB_NO_UNICODE_FUNCS'

include Prelude.mk
