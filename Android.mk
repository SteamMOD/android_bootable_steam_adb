# Copyright 2005 The Android Open Source Project
#
# Android.mk for adb
#

LOCAL_PATH:= $(call my-dir)

# adbd device daemon
# =========================================================

# build adbd in all non-simulator builds
BUILD_ADBD := false
ifneq ($(TARGET_SIMULATOR),true)
    BUILD_ADBD := true
endif

# build adbd for the Linux simulator build
# so we can use it to test the adb USB gadget driver on x86
#ifeq ($(HOST_OS),linux)
#    BUILD_ADBD := true
#endif

ifeq ($(BUILD_ADBD),true)
include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
	adb.c \
	fdevent.c \
	transport.c \
	transport_local.c \
	transport_usb.c \
	sockets.c \
	services.c \
	file_sync_service.c \
	jdwp_service.c \
	framebuffer_service.c \
	remount_service.c \
	usb_linux_client.c \
	log_service.c \
	utils.c

LOCAL_CFLAGS := -Os -g -DADB_HOST=0 -Wall -Wno-unused-parameter
LOCAL_CFLAGS += -D_XOPEN_SOURCE -D_GNU_SOURCE
LOCAL_CFLAGS += -Dmain=steam_adbd_main

# TODO: This should probably be board specific, whether or not the kernel has
# the gadget driver; rather than relying on the architecture type.
ifeq ($(TARGET_ARCH),arm)
LOCAL_CFLAGS += -DANDROID_GADGET=1
endif

LOCAL_MODULE := libsteam_adbd

LOCAL_FORCE_STATIC_EXECUTABLE := true
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT_SBIN)
LOCAL_UNSTRIPPED_PATH := $(TARGET_ROOT_OUT_SBIN_UNSTRIPPED)

ifeq ($(TARGET_SIMULATOR),true)
  LOCAL_STATIC_LIBRARIES := libcutils
  LOCAL_LDLIBS += -lpthread
  include $(BUILD_HOST_EXECUTABLE)
else
  LOCAL_STATIC_LIBRARIES := libcutils libc
  include $(BUILD_STATIC_LIBRARY)
endif

endif
