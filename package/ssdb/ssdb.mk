################################################################################
 #
 # SSDB https://github.com/ideawu/ssdb/archive/1.9.9.tar.gz
 #
 ################################################################################

SSDB_VERSION = 1.9.9
SSDB_SOURCE = $(SSDB_VERSION).tar.gz
SSDB_SITE = https://github.com/ideawu/ssdb/archive
SSDB_LICENSE = GPL-3.0+
SSDB_LICENSE_FILES = COPYING
SSDB_INSTALL_STAGING = YES
# SSDB_CONFIG_SCRIPTS = SSDB-config
SSDB_DEPENDENCIES = host-autoconf

SSDB_MAKE_FLAGS += \  
        CROSS_COMPILE="$(CCACHE) $(TARGET_CROSS)" \  
        CC=$(TARGET_CC)      \  
        OUT_BIN=$(OUT_BIN)  \  
        AR=$(TARGET_AR)      \  
        STRIP=$(TARGET_STRIP) 

define SSDB_BUILD_CMDS
  $(TARGET_CONFIGURE_OPTS)  $(MAKE)  -C $(@D) all
endef

# define SSDB_INSTALL_STAGING_CMDS
#     $(INSTALL) -D -m 0755 $(@D)/SSDB.a $(STAGING_DIR)/usr/lib/SSDB.a
#     $(INSTALL) -D -m 0644 $(@D)/foo.h $(STAGING_DIR)/usr/include/foo.h
#     $(INSTALL) -D -m 0755 $(@D)/SSDB.so* $(STAGING_DIR)/usr/lib
# endef

define SSDB_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0755 $(@D)/ssdb-server $(TARGET_DIR)/usr/bin/ssdb-server
    $(INSTALL) -D -m 0755 $(@D)/tools/ssdb-bench $(TARGET_DIR)/usr/bin/ssdb-bench
    # $(INSTALL) -D -m 0755 $(@D)/tools/ssdb-cli $(TARGET_DIR)/usr/bin/ssdb-cli
    # $(INSTALL) -D -m 0755 $(@D)/tools/ssdb-cli.cpy $(TARGET_DIR)/usr/bin/ssdb-cli.cpy
    $(INSTALL) -D -m 0755 $(@D)/tools/ssdb-dump $(TARGET_DIR)/usr/bin/ssdb-dump
    $(INSTALL) -D -m 0755 $(@D)/tools/ssdb-repair $(TARGET_DIR)/usr/bin/ssdb-repair
    
    $(INSTALL) -D -m 0555 $(@D)/ssdb.conf  $(TARGET_DIR)/etc/ssdb/ssdb.conf
    $(INSTALL) -D -m 0755 $(@D)/ssdb_slave.conf $(TARGET_DIR)/etc/ssdb/ssdb_slave.conf

    # $(INSTALL) -d -m 0755 $(TARGET_DIR)/etc/init.d
endef



 $(eval $(generic-package))