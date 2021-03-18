TARGET = x86_64-w64-mingw32
PREFIX = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))buildroot
STRIP = $(TARGET)-strip --strip-unneeded
