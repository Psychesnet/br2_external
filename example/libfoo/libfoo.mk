LIBFOO_VERSION = 1.0
LIBFOO_SITE = $(BR2_EXTERNAL_PROJECT_PATH)/example/libfoo/src
LIBFOO_SITE_METHOD = local
LIBFOO_INSTALL_STAGING = YES
LIBFOO_INSTALL_TARGET = YES
LIBFOO_LICENSE = Custom

# define build opt
CUSTOM_MAKE_OPTS = CC="$(TARGET_CC)" CFLAGS="$(TARGET_CFLAGS)" \
	CXX="$(TARGET_CXX)" CXXFLAGS="$(TARGET_CXXFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" LIBS="-lpthread"

# define how to call makefile
define LIBFOO_BUILD_CMDS
    $(TARGET_MAKE_ENV) $(MAKE) $(CUSTOM_MAKE_OPTS) -C $(@D) all
endef

# define prefix of nfs debug folder
define LIBFOO_INSTALL_STAGING_CMDS
    $(TARGET_MAKE_ENV) $(MAKE) $(CUSTOM_MAKE_OPTS) \
	INSTALL="$(INSTALL)" DESTDIR="$(STAGING_DIR)" -C $(@D) install

    # we can install .h into staging folder, not target folder
    $(INSTALL) -D -m 0644 $(@D)/foo.h $(STAGING_DIR)/include/foo/foo.h
endef

# define prefix of fakeroot folder
define LIBFOO_INSTALL_TARGET_CMDS
    $(TARGET_MAKE_ENV) $(MAKE) $(CUSTOM_MAKE_OPTS) \
	INSTALL="$(INSTALL)" DESTDIR="$(TARGET_DIR)" -C $(@D) install
endef

# we need this to rsync and build every time
define LIBFOO_POST_REMOVE_STAMP
    rm -f $(@D)/.stamp_*
endef

LIBFOO_POST_INSTALL_STAGING_HOOKS+= LIBFOO_POST_REMOVE_STAMP
LIBFOO_POST_INSTALL_TARGET_HOOKS+= LIBFOO_POST_REMOVE_STAMP

$(eval $(generic-package))
