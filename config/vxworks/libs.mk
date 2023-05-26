#
# $Id: libs.mk 15140 2010-07-17 15:10:48Z vszakats $
#

SYSLIBPATHS :=

ifeq ($(HB_CPU),x86)
   SYSLIBPATHS_BIN := $(WIND_BASE)/target/lib/usr/lib/simpentium/SIMPENTIUM/common
   SYSLIBPATHS_DYN := $(WIND_BASE)/target/lib/usr/lib/simpentium/SIMPENTIUM/common/PIC
else
ifeq ($(HB_CPU),arm)
   SYSLIBPATHS_BIN := $(WIND_BASE)/target/lib/usr/lib/arm/ARMARCH7/common
   SYSLIBPATHS_DYN := $(WIND_BASE)/target/lib/usr/lib/arm/ARMARCH7/common/PIC
endif
endif
