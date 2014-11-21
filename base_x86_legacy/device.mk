# FIXME surfaceflinger explodes if this is not "gmin"
TARGET_BOARD_PLATFORM := gmin

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init.rc:root/init.base_x86_legacy.rc \
    $(LOCAL_PATH)/init.recovery.rc:root/init.recovery.base_x86_legacy.rc \
    $(LOCAL_PATH)/ueventd.rc:root/ueventd.base_x86_legacy.rc \
    $(LOCAL_PATH)/fstab:root/fstab

# These files are extremely board-specific and doesn't go in the mix-in
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/media_profiles.xml:system/etc/media_profiles.xml

#flatland
PRODUCT_PACKAGES += \
        flatland

# FIXME: this should go into a mix-in, but how to organize it?
PRODUCT_AAPT_CONFIG := large xlarge mdpi tvdpi


# ----------------- BEGIN MIX-IN DEFINITIONS -----------------
# Mix-In definitions are auto-generated by mixin-update
##############################################################
# Source: device/intel/mixins/groups/boot-arch/syslinux32/product.mk
##############################################################
PRODUCT_PACKAGES += \
	setup_fs

##############################################################
# Source: device/intel/mixins/groups/kernel/gmin64/product.mk.1
##############################################################
TARGET_KERNEL_ARCH := x86_64

##############################################################
# Source: device/intel/mixins/groups/kernel/gmin64/product.mk
##############################################################

ifneq ($(filter kernel,$(MAKECMDGOALS)),)
  BUILD_KERNEL_FROM_SOURCES := 1
endif

MAKECMDGOALS := $(strip $(filter-out kernel,$(MAKECMDGOALS)))

# if using prebuilts
ifeq ($(BUILD_KERNEL_FROM_SOURCES),)

LOCAL_KERNEL_MODULE_FILES :=
ifeq ($(TARGET_PREBUILT_KERNEL),)
  # use default kernel
  LOCAL_KERNEL_PATH := device/intel/gmin-kernel/$(TARGET_KERNEL_ARCH)
  LOCAL_KERNEL := $(LOCAL_KERNEL_PATH)/bzImage
  LOCAL_KERNEL_MODULE_FILES := $(wildcard $(LOCAL_KERNEL_PATH)/modules/*)
  LOCAL_KERNEL_MODULE_TREE_PATH := $(LOCAL_KERNEL_PATH)/lib/modules
else
  # use custom kernel
  LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
  ifneq ($(TARGET_PREBUILT_KERNEL_MODULE_PATH),)
    LOCAL_KERNEL_MODULE_FILES := $(wildcard $(TARGET_PREBUILT_KERNEL_MODULE_PATH)/*)
  endif
  ifneq ($(TARGET_PREBUILT_KERNEL_MODULE_TREE_PATH),)
    LOCAL_KERNEL_MODULE_TREE_PATH := $(TARGET_PREBUILT_KERNEL_MODULE_TREE_PATH)
  endif
endif

ifneq ($(LOCAL_KERNEL_MODULE_TREE_PATH),)
  LOCAL_KERNEL_VERSION := $(shell file -k $(LOCAL_KERNEL) | sed -nr 's|.*version ([^ ]+) .*|\1|p')
  ifeq ($(LOCAL_KERNEL_VERSION),)
    $(error Cannot get version for kernel '$(LOCAL_KERNEL)')
  endif

  FULL_TREE_PATH := $(LOCAL_KERNEL_MODULE_TREE_PATH)/$(LOCAL_KERNEL_VERSION)
  # Verify FULL_TREE_PATH is an existing folder
  ifneq ($(shell test -d $(FULL_TREE_PATH) && echo 1), 1)
    $(error '$(FULL_TREE_PATH)' does not exist or is not a directory)
  endif

  LOCAL_KERNEL_MODULE_TREE_FILES := $(shell cd $(LOCAL_KERNEL_MODULE_TREE_PATH) && \
                                            find $(LOCAL_KERNEL_VERSION) -type f)
endif

# Copy kernel into place
PRODUCT_COPY_FILES += \
	$(LOCAL_KERNEL):kernel \
	$(foreach f, $(LOCAL_KERNEL_MODULE_FILES), $(f):system/lib/modules/$(notdir $(f))) \
  $(foreach f, $(LOCAL_KERNEL_MODULE_TREE_FILES), $(LOCAL_KERNEL_PATH)/lib/modules/$(f):system/lib/modules/$(f))

endif
##############################################################
# Source: device/intel/mixins/groups/dalvik-heap/tablet-7in-hdpi-1024/product.mk
##############################################################
#include frameworks/native/build/tablet-7in-hdpi-1024-dalvik-heap.mk
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapstartsize=8m \
    dalvik.vm.heapgrowthlimit=100m \
    dalvik.vm.heapsize=174m \
    dalvik.vm.heaptargetutilization=0.75 \
    dalvik.vm.heapminfree=512k \
    dalvik.vm.heapmaxfree=8m
##############################################################
# Source: device/intel/mixins/groups/houdini/true/product.mk
##############################################################
$(call inherit-product-if-exists, vendor/intel/houdini/houdini.mk)

##############################################################
# Source: device/intel/mixins/groups/graphics/software/product.mk
##############################################################
PRODUCT_PACKAGES += \
	libGLES_android \
	egl.cfg \

BOARD_EGL_CFG := device/generic/goldfish/opengl/system/egl/egl.cfg
##############################################################
# Source: device/intel/mixins/groups/media/ufo/product.mk
##############################################################
# libstagefrighthw
BUILD_WITH_FULL_STAGEFRIGHT := true
PRODUCT_PACKAGES += \
    libstagefrighthw

# Media SDK and OMX IL components
PRODUCT_PACKAGES += \
    libmfxhw32 \
    libmfxsw32 \
    libmfx_omx_core \
    libmfx_omx_components_hw \
    libmfx_omx_components_sw \
    libgabi++-mfx \
    libstlport-mfx

# Build OMX wrapper codecs
PRODUCT_PACKAGES += \
    libmdp_omx_core \
    libstagefright_soft_mp3dec_mdp \
    libstagefright_soft_aacdec_mdp \
    libstagefright_soft_aacenc_mdp \
    libstagefright_soft_vorbisdec_mdp \
    libstagefright_soft_amrenc_mdp \
    libstagefright_soft_amrdec_mdp

##############################################################
# Source: device/intel/mixins/groups/sensors/iio/product.mk
##############################################################
PRODUCT_COPY_FILES += \
        frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
        frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
        frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
        frameworks/native/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml

ifeq ($(TARGET_BOARD_PLATFORM),)
    $(error Please define TARGET_BOARD_PLATFORM in product-level Makefile)
endif

# Sensors HAL modules
PRODUCT_PACKAGES += \
        sensors.$(TARGET_BOARD_PLATFORM)

##############################################################
# Source: device/intel/mixins/groups/usb/host/product.mk
##############################################################
PRODUCT_COPY_FILES += frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml

##############################################################
# Source: device/intel/mixins/groups/device-type/tablet/product.mk
##############################################################
PRODUCT_CHARACTERISTICS := tablet

PRODUCT_COPY_FILES += \
        frameworks/native/data/etc/tablet_core_hardware.xml:system/etc/permissions/tablet_core_hardware.xml

##############################################################
# Source: device/intel/mixins/groups/gms/true/product.mk
##############################################################
$(call inherit-product-if-exists, vendor/google/gms/products/intel_gms.mk)
##############################################################
# Source: device/intel/mixins/groups/debug-tools/true/product.mk
##############################################################
# If this a debugging build include the public debug modules
ifneq ($(filter eng userdebug,$(TARGET_BUILD_VARIANT)),)

PRODUCT_PACKAGES += AndroidTerm libjackpal-androidterm4

endif
##############################################################
# Source: device/intel/mixins/groups/art-config/default/product.mk
##############################################################
# This is needed to enable silver art optimizer.
# This will build the plugins/libart-extension.so library,  which is dynamically loaded by
# AOSP and contains Intel optimizations to the compiler.
PRODUCT_PACKAGES += libart-extension
##############################################################
# Source: device/intel/mixins/groups/widevine/default/product.mk
##############################################################
# Make generic definition of media components.
PRODUCT_COPY_FILES += device/intel/common/media/mfx_omxil_core.conf:system/etc/mfx_omxil_core.conf


# ------------------ END MIX-IN DEFINITIONS ------------------
