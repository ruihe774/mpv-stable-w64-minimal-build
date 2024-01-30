DLL_NAME = libharfbuzz-0.dll
MESON_OPTIONS =\
--buildtype=release\
-Dtests=disabled\
-Dfreetype=disabled\
'-Dcpp_args=\
  -DHB_TINY\
  -DHB_NO_OT_FONT\
  -DHB_NO_UCD\
  -DHB_NO_UNICODE_FUNCS'

include Prelude.mk
