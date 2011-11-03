LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE),zeus)
    include $(call all-makefiles-under,$(LOCAL_PATH))
endif
