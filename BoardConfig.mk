include build/make/target/board/generic_arm64/BoardConfig.mk
include device/phh/treble/board-base.mk

ifeq ($(BOARD_SYSTEMIMAGE_PARTITION_RESERVED_SIZE),)
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 2147483648
else
BOARD_SYSTEMIMAGE_PARTITION_RESERVED_SIZE := 33554432
endif

# ROG5-only framework manifest (replaces phh's generic one from board-base.mk)
DEVICE_FRAMEWORK_MANIFEST_FILE := device/asus/I005D/framework_manifest.xml
