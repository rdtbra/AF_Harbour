#
# $Id: Makefile 13165 2009-12-08 10:44:31Z vszakats $
#

ROOT := ../../

#YACC_FLAGS := -p hb_macro
YACC_SOURCE := macro.y
YACC_DEPEND := macrolex.c
YACC_HEADERS := \
   hbmacro.h \
   hbsetup.h \
   hbpcode.h \
   hbdefs.h \

C_SOURCES := \
   macroa.c \
   macrob.c \
   macrolex.c \

LIBNAME := hbmacro

include $(TOP)$(ROOT)config/lib.mk
