#
# $Id: global.mk 14753 2010-06-14 09:59:41Z vszakats $
#

all : first

BIN_EXT :=
DYN_EXT := .so
DYN_PREF := lib

HB_GT_LIBS += gttrm

ifneq ($(filter $(HB_BUILD_STRIP),all lib),)
   ARSTRIP = && strip -S $(LIB_DIR)/$@
endif
ifneq ($(filter $(HB_BUILD_STRIP),all bin),)
   LDSTRIP := -s
   DYSTRIP := -s
endif
