#
# $Id: global.mk 12579 2009-09-21 09:18:24Z vszakats $
#

all : first

BIN_EXT :=
DYN_EXT := .dylib
DYN_PREF := lib

HB_GT_LIBS += gttrm

ifneq ($(filter $(HB_BUILD_STRIP),all lib),)
   ARSTRIP = && strip -S $(LIB_DIR)/$@
endif
ifneq ($(filter $(HB_BUILD_STRIP),all bin),)
   LDSTRIP = && strip $(BIN_DIR)/$@
   DYSTRIP = && strip -S $(DYN_DIR)/$@
endif
