################################################################################
#
# tinyc
#
################################################################################

TINYC_VERSION = mob
TINYC_SITE = https://github.com/TinyCC/tinycc.git
TINYC_SITE_METHOD = git


TINYC_LICENSE = GPL-2.0+ with OpenSSL exception
TINYC_LICENSE_FILES = COPYING COPYING.README
TINYC_CONF_ENV = CFLAGS="$(TARGET_CFLAGS) -std=c99"



TINYC_CONF_OPTS = --enable-static --cross-prefix=arm-linux- --cpu=armv5el  --elfinterp=/lib/ld-linux.so.3 --config-arm-eabi --includedir=/usr/lib/arm-linux-gnueabi/include --libdir=/usr/lib/arm-linux-gnueabi  --crtprefix=/usr/lib/arm-linux-gnueabi  --enable-cross

define TINYC_BUILD_CMDS
  $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) tcc
endef

define TINYC_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/tcc  $(TARGET_DIR)/usr/bin
  $(INSTALL) -d $(TARGET_DIR)/usr/lib/arm-linux-gnueabi/tcc/include/
  $(INSTALL) -m 0644 -D $(@D)/include/*  $(TARGET_DIR)/usr/lib/arm-linux-gnueabi/tcc/include/
  $(INSTALL) -m 0644 -D $(@D)/tcclib.h  $(TARGET_DIR)/usr/lib/arm-linux-gnueabi/tcc/include/
  $(INSTALL) -m 0644 -D $(@D)/libtcc.a  $(TARGET_DIR)/usr/lib/arm-linux-gnueabi/tcc/libtcc1.a
endef

$(eval $(autotools-package))
