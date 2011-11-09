$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)
$(call inherit-product, device/common/gps/gps_eu_supl.mk)

# proprietary side of the device
$(call inherit-product-if-exists, vendor/semc/es209ra/es209ra-vendor.mk)

# Discard inherited values and use our own instead.
PRODUCT_NAME := X10i
PRODUCT_DEVICE := es209ra
PRODUCT_MODEL := X10i


ifeq ($(TARGET_PREBUILT_KERNEL),)
LOCAL_KERNEL := device/semc/es209ra/kernel
else
LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

PRODUCT_COPY_FILES += \
    $(LOCAL_KERNEL):kernel

PRODUCT_PACKAGES += \
    screencap \
    librs_jni \
    gralloc.es209ra \
    copybit.es209ra \
    gps.es209ra \
    lights.es209ra \
    libOmxCore \
    libOmxVdec \
    libOmxVidEnc \
    libmm-omxcore \
    com.android.future.usb.accessory \
    rzscontrol

#PRODUCT_SPECIFIC_DEFINES += TARGET_PRELINKER_MAP=$(TOP)/device/semc/es209ra/prelink-linux-arm-x10.map

# These is the hardware-specific overlay, which points to the location
# of hardware-specific resource overrides, typically the frameworks and
# application settings that are stored in resourced.
DEVICE_PACKAGE_OVERLAYS += device/semc/es209ra/overlay

# kernel.sin prebuilt for now
PRODUCT_COPY_FILES += \
    device/semc/es209ra/prebuilt/kernel.sin:system/kernel.sin

# These are the hardware-specific configuration files
PRODUCT_COPY_FILES += \
	device/semc/es209ra/prebuilt/media_profiles.xml:system/etc/media_profiles.xml \
	device/semc/es209ra/prebuilt/gps.conf:system/etc/gps.conf 

# Init files
PRODUCT_COPY_FILES += \
    device/semc/es209ra/prebuilt/init.es209ra.rc:root/init.es209ra.rc \
    device/semc/es209ra/prebuilt/init.bt.sh:system/etc/init.bt.sh \
    device/semc/es209ra/prebuilt/DualMicControl.txt:system/etc/DualMicControl.txt \
    device/semc/es209ra/prebuilt/ueventd.es209ra.rc:root/ueventd.es209ra.rc \
    device/semc/es209ra/prebuilt/hw_config.sh:system/etc/hw_config.sh \
    device/semc/es209ra/prebuilt/bootrec:root/sbin/bootrec \
    device/semc/es209ra/recovery.fstab:root/recovery.fstab \
    device/semc/es209ra/prebuilt/vold.fstab:system/etc/vold.fstab \
    device/semc/es209ra/prebuilt/initlogo.rle:root/initlogo.rle 


#WIFI modules and configs
PRODUCT_COPY_FILES += \
    device/semc/es209ra/prebuilt/10dnsconf:system/etc/init.d/10dnsconf \
    device/semc/es209ra/prebuilt/10regcode:system/etc/init.d/10regcode \
    device/semc/es209ra/prebuilt/10cpmodules:system/etc/init.d/10cpmodules \
    device/semc/es209ra/prebuilt/10hostapconf:system/etc/init.d/10hostapconf \
    device/semc/es209ra/prebuilt/dnsmasq.conf:system/etc/wifi/dnsmasq.conf \
    device/semc/es209ra/prebuilt/wpa_supplicant.conf:system/etc/wifi/wpa_supplicant.conf \
    device/semc/es209ra/prebuilt/hostapd:system/bin/hostapd \
    device/semc/es209ra/prebuilt/reg_code:system/etc/wifi/reg_code \
    device/semc/es209ra/prebuilt/hostapd.conf:system/etc/wifi/softap/hostapd.conf \
    device/semc/es209ra/modules/ar6000.ko:root/modules/ar6000.ko

#recovery resources
PRODUCT_COPY_FILES += \
    bootable/recovery/res/images/icon_firmware_error.png:root/res/images/icon_firmware_error.png \
    bootable/recovery/res/images/icon_firmware_install.png:root/res/images/icon_firmware_install.png \
    bootable/recovery/res/images/icon_clockwork.png:root/res/images/icon_clockwork.png \
    bootable/recovery/res/images/icon_error.png:root/res/images/icon_error.png \
    bootable/recovery/res/images/icon_installing.png:root/res/images/icon_installing.png \
    bootable/recovery/res/images/indeterminate1.png:root/res/images/indeterminate1.png \
    bootable/recovery/res/images/indeterminate2.png:root/res/images/indeterminate2.png \
    bootable/recovery/res/images/indeterminate3.png:root/res/images/indeterminate3.png \
    bootable/recovery/res/images/indeterminate4.png:root/res/images/indeterminate4.png \
    bootable/recovery/res/images/indeterminate5.png:root/res/images/indeterminate5.png \
    bootable/recovery/res/images/indeterminate6.png:root/res/images/indeterminate6.png \
    bootable/recovery/res/images/progress_empty.png:root/res/images/progress_empty.png \
    bootable/recovery/res/images/progress_fill.png:root/res/images/progress_fill.png

PRODUCT_COPY_FILES += \
    frameworks/base/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
    frameworks/base/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/base/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/base/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/base/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/base/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/base/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
    frameworks/base/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/base/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

#Offline charging animation
PRODUCT_COPY_FILES += \
    device/semc/msm7x30-common/prebuilt/animations/charging_animation_01_H.png:system/semc/chargemon/data/charging_animation_01.png \
    device/semc/msm7x30-common/prebuilt/animations/charging_animation_02_H.png:system/semc/chargemon/data/charging_animation_02.png \
    device/semc/msm7x30-common/prebuilt/animations/charging_animation_03_H.png:system/semc/chargemon/data/charging_animation_03.png \
    device/semc/msm7x30-common/prebuilt/animations/charging_animation_04_H.png:system/semc/chargemon/data/charging_animation_04.png \
    device/semc/msm7x30-common/prebuilt/animations/charging_animation_05_H.png:system/semc/chargemon/data/charging_animation_05.png \
    device/semc/msm7x30-common/prebuilt/animations/charging_animation_06_H.png:system/semc/chargemon/data/charging_animation_06.png \
    device/semc/msm7x30-common/prebuilt/animations/charging_animation_07_H.png:system/semc/chargemon/data/charging_animation_07.png \
    device/semc/msm7x30-common/prebuilt/animations/charging_animation_blank_H.png:system/semc/chargemon/data/charging_animation_blank.png


PRODUCT_PROPERTY_OVERRIDES += \
    rild.libpath=/system/lib/libril-qc-1.so \
    rild.libargs=-d/dev/smd0 \
    ro.ril.hsxpa=1 \
    ro.ril.gprsclass=10 \
    ro.telephony.default_network=0 \
    ro.telephony.call_ring.multiple=false \
    wifi.interface=wlan0 \
    wifi.supplicant_scan_interval=15 \
    ro.sf.lcd_density=240 \
    qemu.sf.lcd_density=240 \
    keyguard.no_require_sim=true \
    ro.com.google.locationfeatures=1 \
    dalvik.vm.dexopt-flags=m=y \
    dalvik.vm.heapsize=32m \
    dalvik.vm.dexopt-data-only=1 \
    dalvik.vm.lockprof.threshold=500 \
    dalvik.vm.execution-mode=int:jit \
    dalvik.vm.checkjni=false \
    ro.opengles.version=131072  \
    ro.compcache.default=0 \
    ro.product.locale.language=en \
    ro.product.locale.region=US \
    persist.ro.ril.sms_sync_sending=1 \
    ro.camera.hd_shrink_vf_enabled=1 \
    persist.android.strictmode=0 \
    BUILD_UTC_DATE=0

# es209ra uses high-density artwork where available
PRODUCT_LOCALES += hdpi

# we have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise


