HELLO_VERSION = 1.0
HELLO_SITE = $(BR2_EXTERNAL_PROJECT_PATH)/example/hello/src
HELLO_SITE_METHOD = local
HELLO_INSTALL_STAGING = YES
HELLO_INSTALL_TARGET = YES
HELLO_LICENSE = Custom

# define build opt
CUSTOM_MAKE_OPTS = CC="$(TARGET_CC)" CFLAGS="$(TARGET_CFLAGS)" \
	CXX="$(TARGET_CXX)" CXXFLAGS="$(TARGET_CXXFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" LIBS="-lpthread"

# $(@D) is output/build/hello-custom folder
# define how to call makefile
define HELLO_BUILD_CMDS
    $(TARGET_MAKE_ENV) $(MAKE) $(CUSTOM_MAKE_OPTS) -C $(@D) all
endef

# define prefix of nfs debug folder
define HELLO_INSTALL_STAGING_CMDS
    $(TARGET_MAKE_ENV) $(MAKE) $(CUSTOM_MAKE_OPTS) \
	INSTALL="$(INSTALL)" DESTDIR="$(STAGING_DIR)" -C $(@D) install
endef

# define prefix of fakeroot folder
define HELLO_INSTALL_TARGET_CMDS
    $(TARGET_MAKE_ENV) $(MAKE) $(CUSTOM_MAKE_OPTS) \
	INSTALL="$(INSTALL)" DESTDIR="$(TARGET_DIR)" -C $(@D) install
endef

# we need this to do rsync and build every time
define HELLO_POST_REMOVE_STAMP
    rm -f $(@D)/.stamp_*
endef

HELLO_POST_INSTALL_STAGING_HOOKS+= HELLO_POST_REMOVE_STAMP
HELLO_POST_INSTALL_TARGET_HOOKS+= HELLO_POST_REMOVE_STAMP

$(eval $(generic-package))
