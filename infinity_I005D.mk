TARGET_GAPPS_ARCH := arm64
include build/make/target/product/aosp_arm64.mk
$(call inherit-product, device/asus/I005D/device.mk)
$(call inherit-product, device/phh/treble/infinity.mk)

PRODUCT_NAME := infinity_I005D
PRODUCT_DEVICE := I005D
PRODUCT_BRAND := asus
PRODUCT_SYSTEM_BRAND := asus
PRODUCT_MANUFACTURER := asus
PRODUCT_SYSTEM_MANUFACTURER := asus

PRODUCT_MODEL := ASUS_I005DA
PRODUCT_SYSTEM_MODEL := ASUS_I005DA
PRODUCT_SYSTEM_NAME := WW_I005D
PRODUCT_SYSTEM_DEVICE := ASUS_I005_1

# Overwrite the inherited "emulator" characteristics
PRODUCT_CHARACTERISTICS := device

# Infinity ships GApps from vendor/google/gms when WITH_GAPPS is true.
WITH_GAPPS := true
