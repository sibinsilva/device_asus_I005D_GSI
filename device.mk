# ASUS ROG Phone 5 / 5s (anakin / ASUS_I005) Stock-Vendor Device Configuration

PRODUCT_COPY_FILES := \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:system/etc/permissions/android.hardware.fingerprint.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.telephony.ims.xml:system/etc/permissions/android.hardware.telephony.ims.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:system/etc/permissions/android.hardware.wifi.passpoint.xml \
    frameworks/native/data/etc/android.software.secure_lock_screen.xml:system/etc/permissions/android.software.secure_lock_screen.xml \
    device/phh/treble/files/android.software.controls.xml:system/etc/permissions/android.software.controls.xml \
    device/phh/treble/interfaces.xml:system/etc/permissions/interfaces.xml \
    device/phh/treble/files/com.android.deskclock_whitelist.xml:system/etc/sysconfig/com.android.deskclock_whitelist.xml

# Bluetooth Audio (System-side HAL, sysbta)
PRODUCT_PACKAGES += \
    audio.sysbta.default \
    android.hardware.bluetooth.audio-service-system

PRODUCT_COPY_FILES += \
    device/phh/treble/bluetooth/audio/config/sysbta_audio_policy_configuration.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysbta_audio_policy_configuration.xml \
    device/phh/treble/bluetooth/audio/config/sysbta_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysbta_audio_policy_configuration_7_0.xml \
    frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration_7_0.xml:system/etc/a2dp_audio_policy_configuration_7_0.xml \
    frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:system/etc/a2dp_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:system/etc/usb_audio_policy_configuration.xml \
    device/phh/treble/files/fake_audio_policy_volume.xml:system/etc/fake_audio_policy_volume.xml

SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += device/phh/treble/sepolicy
PRODUCT_PACKAGE_OVERLAYS += device/asus/I005D/overlay

# Include only ASUS ROG Phone 5/5s + Qualcomm CAF overlays (excludes 500+ foreign OEM overlays)
PRODUCT_PACKAGES += \
    QtiAudio \
    TrebleApp \
    treble-overlay-NavBar \
    treble-overlay-NightMode \
    treble-overlay-SystemUI-FalseLocks \
    treble-overlay-Telephony-LTE \
    treble-overlay-asus-rog5-5s \
    treble-overlay-asus-rog5_5s-wifi \
    treble-overlay-caf-ims \
    treble-overlay-devinputjack \
    treble-overlay-highpriomisc \
    treble-overlay-misc-aod \
    treble-overlay-misc-aod-systemui \
    treble-overlay-misc-biometrics \
    treble-overlay-misc-dt2w \
    treble-overlay-misc-minimal-brightness \
    treble-overlay-telephony-caf-ims \
    treble-overlay-tethering \
    treble-overlay-tethering-nobpf \
    treble-overlay-wifi \
    treble-overlay-wifi5g

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base_telephony.mk)

PRODUCT_PACKAGES += apns-conf.xml

TARGET_SYSTEM_PROP += device/asus/I005D/system.prop

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.build.version.sdk=$(PLATFORM_SDK_VERSION) \
    ro.build.version.codename=$(PLATFORM_VERSION_CODENAME) \
    ro.build.version.all_codenames=$(PLATFORM_VERSION_ALL_CODENAMES) \
    ro.build.version.release=$(PLATFORM_VERSION) \
    ro.build.version.security_patch=$(PLATFORM_SECURITY_PATCH) \
    ro.adb.secure?=0 \
    ro.logd.auditd=true \
    ro.logd.kernel=true \
    ro.sf.lcd_density=440 \
    debug.fdsan=warn_once \
    debug.stagefright.c2inputsurface=-1 \
    persist.sys.fflag.override.settings_provider_model=false \
    ro.setupwizard.mode=OPTIONAL

PRODUCT_PRODUCT_PROPERTIES += \
    ro.setupwizard.mode=OPTIONAL

# VNDK, Charger, and ASUS ROG Phone 5/5s init scripts
PRODUCT_COPY_FILES += \
    device/phh/treble/vndk-detect:system/bin/vndk-detect \
    device/phh/treble/vndk.rc:system/etc/init/vndk.rc \
    device/phh/treble/charger.rc:system/etc/init/charger.rc \
    device/phh/treble/rog5-fixups.rc:system/etc/init/rog5-fixups.rc \
    device/asus/I005D/keylayout/fts_ts.kl:$(TARGET_COPY_OUT_SYSTEM)/usr/keylayout/fts_ts.kl \
    device/phh/treble/files/wifi-apexdata.rc:$(TARGET_COPY_OUT_SYSTEM)/etc/init/wifi-apexdata.rc \
    device/asus/I005D/files/rw-system.sh:system/bin/rw-system.sh \
    device/phh/treble/phh-on-boot.sh:system/bin/phh-on-boot.sh \
    device/phh/treble/power-mode-monitor.sh:system/bin/power-mode-monitor.sh \
    device/phh/treble/phh-on-data.sh:system/bin/phh-on-data.sh \
    device/phh/treble/phh-prop-handler.sh:system/bin/phh-prop-handler.sh \
    device/phh/treble/fixSPL/getSPL.arm:system/bin/getSPL \
    device/phh/treble/twrp/busybox-armv7l:system/bin/busybox_phh \
    device/phh/treble/files/adbd.rc:system/etc/init/adbd.rc \
    device/phh/treble/00-fix-metadata.rc:system/etc/init/00-fix-metadata.rc \
    device/phh/treble/00-fix-metadata.sh:system/etc/00-fix-metadata.sh \
    device/phh/treble/privapp-permissions-me.phh.treble.app.xml:system/etc/permissions/privapp-permissions-me.phh.treble.app.xml \
    device/phh/treble/sysconfig-me.phh.treble.app.xml:system/etc/sysconfig/sysconfig-me.phh.treble.app.xml

PRODUCT_PACKAGES += \
    product_charger_res_images \
    charger_res_images \
    treble-environ-rc \
    bootctl \
    vintf \
    simg2img_simple \
    lptools \
    mkfs.exfat \
    fsck.exfat \
    android.hidl.manager-V1.0-java \
    vendor.qti.hardware.radio.am-V1.0-java \
    vendor.qti.qcril.am-V1.0-java \
    lightsctl \
    lightsctl-aidl \
    uevent \
    Stk \
    resetprop_phh \
    android.hardware.biometrics.fingerprint@2.3-service.anakin \
    AsusCamera \
    ROG5FrameworkOverlay \
    curl \
    NavigationBarMode2ButtonOverlay \
    evgrab \
    QcRilAm \
    Iwlan \
    QualifiedNetworksService

include build/make/target/product/gsi_release.mk

$(call inherit-product, $(SRC_TARGET_DIR)/product/window_extensions.mk)
PRODUCT_PRODUCT_PROPERTIES += \
    persist.settings.large_screen_opt.enabled=true

PRODUCT_EXTRA_VNDK_VERSIONS += 28 29 30

$(call inherit-product, device/phh/treble/flags.mk)

PRODUCT_PACKAGES += \
    LatinIME \
    Jelly \
    SoundPicker

PRODUCT_PACKAGES := $(filter-out Seedvault Twelve,$(PRODUCT_PACKAGES))
