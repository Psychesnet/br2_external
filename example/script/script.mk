SCRIPT_VERSION = 1.0
SCRIPT_SITE = $(BR2_EXTERNAL_PROJECT_PATH)/example/script/src
SCRIPT_SITE_METHOD = local
SCRIPT_INSTALL_STAGING = YES
SCRIPT_INSTALL_TARGET = YES
SCRIPT_LICENSE = Custom

# define how to call makefile
define SCRIPT_BUILD_CMDS
    echo "Just script folder"
endef

# define prefix of nfs debug folder
define SCRIPT_INSTALL_STAGING_CMDS
    $(INSTALL) -D -m 0755 $(@D)/script.sh $(STAGING_DIR)/bin/script.sh
endef

# define prefix of fakeroot folder
define SCRIPT_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0755 $(@D)/script.sh $(TARGET_DIR)/bin/script.sh
endef

# we need this to do rsync and build every time
define SCRIPT_POST_REMOVE_STAMP
    rm -f $(@D)/.stamp_*
endef

SCRIPT_POST_INSTALL_STAGING_HOOKS+= SCRIPT_POST_REMOVE_STAMP
SCRIPT_POST_INSTALL_TARGET_HOOKS+= SCRIPT_POST_REMOVE_STAMP

$(eval $(generic-package))
