-include device/semc/mogami-common/BoardConfigCommon.mk
-include vendor/semc/anzu/BoardConfigVendor.mk

TARGET_SPECIFIC_HEADER_PATH := device/semc/anzu/include

HDMI_DUAL_DISPLAY := true
TARGET_HAVE_HDMI_OUT := true

TARGET_OTA_ASSERT_DEVICE := LT18i,LT18a,LT15i,LT15a,anzu
