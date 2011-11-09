LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE),es209ra)
    include $(call all-makefiles-under,$(LOCAL_PATH))
endif
