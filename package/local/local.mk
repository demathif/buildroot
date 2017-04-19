################################################################################
#
# local
#
################################################################################

LOCAL_VERSION = 1.0
LOCAL_SOURCE =
LOCAL_SITE =
LOCAL_LICENSE =
LOCAL_INSTALL_STAGING = YES
LOCAL_DEPENDENCIES =

define LOCAL_BUILD_CMDS
$(MAKE) CC="$(TARGET_CC)" LD="$(TARGET_LD)" $(TARGET_CONFIGURE_OPTS) -C $(@D)
$(@D)/test.sh --create --prefix $(@D) --format 12 --file file12.img --loop 0 --name FAT12
$(@D)/test.sh --create --prefix $(@D) --format 16 --file file16.img --loop 1 --name FAT16
$(@D)/test.sh --create --prefix $(@D) --format 32 --file file32.img --loop 2 --name FAT32
$(@D)/test.sh --create --prefix $(@D) --format 32 --file file.img --loop 3 --name no
endef

define LOCAL_INSTALL_STAGING_CMDS
$(INSTALL) -D -m 0755 $(@D)/eudyptula $(STAGING_DIR)/usr/bin
endef

define LOCAL_INSTALL_TARGET_CMDS
$(INSTALL) -D -m 0755 $(@D)/eudyptula $(TARGET_DIR)/usr/bin
$(INSTALL) -D -m 0777 $(@D)/test.sh $(TARGET_DIR)/root
$(INSTALL) -D -m 0777 $(@D)/file12.img $(TARGET_DIR)/root
$(INSTALL) -D -m 0777 $(@D)/file16.img $(TARGET_DIR)/root
$(INSTALL) -D -m 0777 $(@D)/file32.img $(TARGET_DIR)/root
$(INSTALL) -D -m 0777 $(@D)/file.img $(TARGET_DIR)/root
endef

$(eval $(generic-package))
