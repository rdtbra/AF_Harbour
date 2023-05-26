#
# $Id: Makefile 15335 2010-08-07 10:00:21Z vszakats $
#

ROOT := ../../

PRG_SOURCES := \
   hbi18n.prg \

PRG_MAIN := hbi18n.prg

LIBS = $(HB_LIBS_ST_NORDD)

ifneq ($(filter $(HB_PLATFORM),win wce os2),)
   ifneq ($(HB_BUILD_DYN),no)
      HB_BUILD_SHARED := yes
   endif
endif

include $(TOP)$(ROOT)config/bin.mk
