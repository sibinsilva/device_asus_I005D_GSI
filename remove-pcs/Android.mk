LOCAL_PATH := $(call my-dir)

# Keep Private Compute Services (com.google.android.as.oss) out of the image.
# It needs android.system.virtualmachine classes from framework-virtualization,
# which is not on the boot classpath here because com.android.virt does not
# activate on the ROG5, so the app crash-loops with NoClassDefFoundError.
include $(CLEAR_VARS)
LOCAL_MODULE := rog5-remove-pcs
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_TAGS := optional
LOCAL_SRC_FILES := rog5-remove-pcs.txt
LOCAL_MODULE_PATH := $(TARGET_OUT_ETC)
# Same mechanism as device/phh/treble/overrides: main.mk's module-overrides
# reads PACKAGES.<module>.OVERRIDES, which LOCAL_OVERRIDES_PACKAGES only sets
# for app modules, not for this ETC prebuilt.
PACKAGES.$(LOCAL_MODULE).OVERRIDES := DeviceIntelligenceNetworkPrebuiltAstrea
LOCAL_UNINSTALLABLE_MODULE := true
include $(BUILD_PREBUILT)
