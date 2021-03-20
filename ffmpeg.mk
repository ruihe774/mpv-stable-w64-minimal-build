NO_DIST = 1

include Prelude.mk

UNARCHIVED = $(DOWNLOADS)/ffmpeg
ARCHIVE = $(DOWNLOADS)/ffmpeg.7z
URL = https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-full-shared.7z

libs = libavformat libavcodec libavutil libavfilter libswresample libswscale
implib = $(addsuffix .dll.a, $(libs))
pc = $(addsuffix .pc, $(libs))
implib_path = $(addprefix $(LIB)/,$(implib))
pc_path = $(addprefix $(PKGCFG)/,$(pc))
header_path = $(addprefix $(INCLUDE)/,$(libs))

build: $(implib_path) $(pc_path) $(header_path)

$(implib_path): $(UNARCHIVED)
	cp $</lib/$(notdir $@) $@

$(header_path): $(UNARCHIVED)
	cp -r $</include/$(notdir $@) $@

$(pc_path):
	cp $(SRC)/ffmpeg.files/$(notdir $@) $@

$(UNARCHIVED): $(ARCHIVE)
	rm -r $(UNARCHIVED) $(DOWNLOADS)/ffmpeg-*-full_build-shared
	cd $(DOWNLOADS) && p7zip -d -k $(notdir $<)
	cd $(DOWNLOADS) && mv -T ffmpeg-*-full_build-shared $(notdir $@)
	touch $@

$(ARCHIVE):
	wget '$(URL)' -O $(addsuffix .tmp,$@)
	mv $(addsuffix .tmp,$@) $@

clean:
	rm -r $(pc_path) $(header_path) $(implib_path)

distclean: clean
	rm -r $(UNARCHIVED) $(ARCHIVE)
