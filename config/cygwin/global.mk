#
# $Id: global.mk 15722 2010-11-01 12:58:15Z vszakats $
#

all : first

BIN_EXT := .exe
DYN_EXT := .dll
DYN_PREF := cyg

HB_GT_LIBS += gttrm

ifneq ($(filter $(HB_BUILD_STRIP),all lib),)
   ARSTRIP = && strip -S $(LIB_DIR)/$@
endif
ifneq ($(filter $(HB_BUILD_STRIP),all bin),)
   LDSTRIP := -s
   DYSTRIP := -s
endif
