#
# $Id: Makefile 16398 2011-02-28 17:13:06Z druzus $
#

ROOT := ../../

include $(TOP)$(ROOT)config/global.mk

PRG_SOURCES := \
   hbmk2.prg \

PRG_MAIN := hbmk2.prg

LIBS = $(HB_LIBS_MT_NORDD)

ifneq ($(HB_HAS_GPM),)
   HB_PRGFLAGS += -DHB_HAS_GPM
endif
ifneq ($(HB_HAS_WATT),)
   HB_PRGFLAGS += -DHB_HAS_WATT
endif

include $(TOP)$(ROOT)config/bin.mk
