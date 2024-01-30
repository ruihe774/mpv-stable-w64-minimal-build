NO_DIST = 1

include Prelude.mk

UNARCHIVED = $(DOWNLOADS)/vulkan-loader
ARCHIVE = $(DOWNLOADS)/mingw-w64-x86_64-vulkan-loader-1.3.275.0-1-any.pkg.tar.zst
URL = https://repo.msys2.org/mingw/mingw64/mingw-w64-x86_64-vulkan-loader-1.3.275.0-1-any.pkg.tar.zst

implib = libvulkan-1.dll.a
pc = vulkan.pc
implib_path = $(LIB)/$(implib)
pc_path = $(PKGCFG)/$(pc)

build: $(implib_path) $(pc_path)

$(implib_path): $(UNARCHIVED)
	cp $</mingw64/lib/$(notdir $@) $@

$(pc_path): $(UNARCHIVED)
	cp $</mingw64/lib/pkgconfig/$(notdir $@) $@

$(UNARCHIVED): $(ARCHIVE)
	-rm -r $@
	mkdir $@
	cd $@ && tar -xf $<

$(ARCHIVE):
	wget '$(URL)' -O $(addsuffix .tmp,$@)
	mv $(addsuffix .tmp,$@) $@

clean:
	-rm -r $(pc_path) $(implib_path)

distclean: clean
	-rm -r $(UNARCHIVED) $(ARCHIVE)
