#
# $Id: global.mk 15328 2010-08-06 12:35:40Z vszakats $
#

all : first

BIN_EXT := .exe
DYN_EXT := .dll
DYN_PREF :=

ifneq ($(filter $(HB_BUILD_STRIP),all lib),)
   ARSTRIP = && $(HB_CCPREFIX)strip -S $(LIB_DIR)/$@
endif
ifneq ($(filter $(HB_BUILD_STRIP),all bin),)
   LDSTRIP := -s
   DYSTRIP := -s
endif
