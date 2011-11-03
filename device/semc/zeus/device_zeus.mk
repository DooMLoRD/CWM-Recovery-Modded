$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)
$(call inherit-product, device/common/gps/gps_eu_supl.mk)

# proprietary side of the device
$(call inherit-product-if-exists, vendor/semc/zeus/zeus-vendor.mk)


# Discard inherited values and use our own instead.
PRODUCT_NAME := zeus
PRODUCT_DEVICE := zeus
PRODUCT_MODEL := zeus


ifeq ($(TARGET_PREBUILT_KERNEL),)
LOCAL_KERNEL := device/semc/zeus/kernel
else
LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

-include device/semc/zeus-common/zeus.mk

PRODUCT_COPY_FILES += \
    $(LOCAL_KERNEL):kernel

# These is the hardware-specific overlay, which points to the location
# of hardware-specific resource overrides, typically the frameworks and
# application settings that are stored in resourced.
DEVICE_PACKAGE_OVERLAYS += device/semc/zeus/overlay

# These are the hardware-specific configuration files
PRODUCT_COPY_FILES += \
	device/semc/zeus/prebuilt/media_profiles.xml:system/etc/media_profiles.xml

# Init files
PRODUCT_COPY_FILES += \
    device/semc/msm7x30-common/prebuilt/logo_H.rle:root/logo.rle \
    device/semc/zeus/prebuilt/hw_config.sh:system/etc/hw_config.sh \
    device/semc/zeus/prebuilt/bootrec:root/sbin/bootrec

#WIFI modules
PRODUCT_COPY_FILES += \
    device/semc/zeus/modules/bcm4329.ko:root/modules/bcm4329.ko

# semc msm7x30 uses high-density artwork where available
PRODUCT_LOCALES += hdpi

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
    ro.telephony.ril_class=semc \
    wifi.interface=eth0 \
    wifi.supplicant_scan_interval=15 \
    ro.sf.lcd_density=240 \
    keyguard.no_require_sim=true \
    ro.com.google.locationfeatures=1 \
    dalvik.vm.dexopt-flags=m=y \
    dalvik.vm.heapsize=32m \
    dalvik.vm.dexopt-data-only=1 \
    dalvik.vm.lockprof.threshold=500 \
    dalvik.vm.execution-mode=int:jit \
    dalvik.vm.checkjni=false \
    ro.kernel.android.checkjni=0 \
    ro.opengles.version=131072  \
    ro.tethering.kb_disconnect=1 \
    ro.compcache.default=0 \
    ro.product.locale.language=en \
    ro.product.locale.region=US \
    BUILD_UTC_DATE=0
