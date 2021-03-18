include Prelude.mk

LIB = $(PREFIX)/lib
PKGCFG = $(PREFIX)/lib/pkgconfig
INCLUDE = $(PREFIX)/include
DOWNLOADS = downloads
UNARCHIVED = $(DOWNLOADS)/ffmpeg
ARCHIVE = $(DOWNLOADS)/ffmpeg.7z
URL = https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-full-shared.7z

libs = libavformat libavcodec libavutil libavfilter libswresample libswscale
libas = $(addsuffix .dll.a, $(libs))
pcs = $(addsuffix .pc, $(libs))

build: $(addprefix $(LIB)/, $(libas)) $(addprefix $(PKGCFG)/, $(pcs)) $(addprefix $(INCLUDE)/, $(libs))

$(addprefix $(LIB)/, $(libas)): $(UNARCHIVED)
	cp $</lib/$(notdir $@) $@

$(addprefix $(INCLUDE)/, $(libs)): $(UNARCHIVED)
	cp -r $</include/$(notdir $@) $@

$(addprefix $(PKGCFG)/, $(pcs)):
	cp ffmpeg.files/$(notdir $@) $@

$(UNARCHIVED): $(ARCHIVE)
	cd $(DOWNLOADS) && p7zip -d -k $(notdir $<)
	cd $(DOWNLOADS) && mv -T ffmpeg-*-full_build-shared $(notdir $@)

$(ARCHIVE):
	wget '$(URL)' -O $(addsuffix .tmp, $@)
	mv $(addsuffix .tmp, $@) $@

clean:
	rm -r $(addprefix $(PKGCFG)/, $(pcs)) $(addprefix $(INCLUDE)/, $(libs)) $(addprefix $(LIB)/, $(libas))

distclean: clean
	rm -r $(UNARCHIVED) $(ARCHIVE)

.PHONY: build clean distclean
