ifneq ($(filter mogami zeus, $(TARGET_BOOTLOADER_BOARD_NAME)),)
    include $(all-subdir-makefiles)
endif
