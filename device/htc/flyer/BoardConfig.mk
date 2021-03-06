USE_CAMERA_STUB := true

# inherit from the proprietary version
-include vendor/htc/flyer/BoardConfigVendor.mk

TARGET_NO_BOOTLOADER := true
TARGET_BOARD_PLATFORM := msm7x30
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_BOOTLOADER_BOARD_NAME := flyer

BOARD_KERNEL_CMDLINE := no_console_suspend=1
BOARD_KERNEL_BASE := 0x14400000
BOARD_PAGE_SIZE := 0x00000800

TARGET_PREBUILT_KERNEL := device/htc/flyer/kernel

BOARD_CUSTOM_RECOVERY_KEYMAPPING := ../../device/htc/flyer/recovery/recovery_ui.c

BOARD_HAS_NO_SELECT_BUTTON := true
# Use this flag if the board has a ext4 partition larger than 2gb
#BOARD_HAS_LARGE_FILESYSTEM := true
