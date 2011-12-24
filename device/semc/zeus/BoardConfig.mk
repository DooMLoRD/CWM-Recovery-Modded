-include device/semc/zeus-common/BoardConfigCommon.mk
-include vendor/semc/zeus/BoardConfigVendor.mk

TARGET_SPECIFIC_HEADER_PATH := device/semc/zeus/include

TARGET_OTA_ASSERT_DEVICE := R800i,R800a,R800at,zeus

BOARD_CUSTOM_RECOVERY_KEYMAPPING := ../../device/semc/msm7x30-common/recovery-zeus/recovery_ui.c

BOARD_UMS_LUNFILE := /sys/devices/platform/msm_hsusb/gadget/lun0/file
