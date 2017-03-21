#############################################################
#
# jailhouse
#
#############################################################
JAILHOUSE_VERSION = 0.6
JAILHOUSE_SOURCE = v$(JAILHOUSE_VERSION).tar.gz
JAILHOUSE_SITE = https://github.com/siemens/jailhouse/archive
JAILHOUSE_LICENSE = GPLv2
JAILHOUSE_LICENSE_FILES = COPYING


define JAILHOUSE_INSTALL_TARGET_CMDS
	$(MAKE) KDIR=$(LINUX_DIR) -C $(@D) CC="$(TARGET_CC)" DESTDIR="$(TARGET_DIR)" install
	mkdir -p $(TARGET_DIR)/root/configs
	$(INSTALL) -D -m 0644 $(@D)/configs/*.{cell,c} $(TARGET_DIR)/root/configs
endef

$(eval $(kernel-module))
$(eval $(generic-package))
