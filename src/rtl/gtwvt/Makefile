#
# $Id: Makefile 12471 2009-09-11 01:49:57Z vszakats $
#

ROOT := ../../../

include $(TOP)$(ROOT)config/global.mk

LIBNAME := gtwvt

C_SOURCES := \
   gtwvt.c \

ifneq ($(filter $(HB_PLATFORM),win wce),)
   include $(TOP)$(ROOT)config/lib.mk
else
   HB_SKIP_REASON := platform not supported
   include $(TOP)$(ROOT)config/none.mk
endif
