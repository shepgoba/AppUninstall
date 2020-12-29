TARGET := iphone:clang:latest:7.0
export ARCHS = armv7 arm64 arm64e
include $(THEOS)/makefiles/common.mk

TOOL_NAME = AppUninstall

AppUninstall_FILES = main.m
AppUninstall_CFLAGS = -fobjc-arc -O3
AppUninstall_CODESIGN_FLAGS = -Sent.xml
AppUninstall_INSTALL_PATH = /usr/local/bin
AppUninstall_FRAMEWORKS = Foundation
AppUninstall_PRIVATE_FRAMEWORKS = CoreServices
include $(THEOS_MAKE_PATH)/tool.mk
