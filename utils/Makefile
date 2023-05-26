#
# $Id: Makefile 16255 2011-02-09 01:28:20Z vszakats $
#

ROOT := ../

ifneq ($(HB_BUILD_PARTS),lib)

DIRS := \
   hbmk2 \

ifneq ($(HB_BUILD_PARTS),compiler)

   DIRS += \
      hbi18n \
      hbtest \
      $(__HB_UTIL_ADDONS)

endif

endif

ifneq ($(DIRS),)
   include $(ROOT)config/dir.mk
else
   include $(ROOT)config/none.mk
endif
