#
# $Id: clang.mk 16651 2011-04-22 14:29:59Z vszakats $
#

ifeq ($(HB_BUILD_MODE),cpp)
   HB_CMP := clang++
else
   HB_CMP := clang
endif

HB_BUILD_SHARED := no
HB_BUILD_DYN := no

OBJ_EXT := .o
LIB_PREF := lib
LIB_EXT := .a

## HB_DYN_COPT := -DHB_DYNLIB -fPIC

CC := $(HB_CCACHE) $(HB_CCPREFIX)$(HB_CMP)$(HB_CCPOSTFIX)
ifneq ($(filter --analyze, $(HB_USER_CFLAGS)),)
   CC_IN :=
else
   CC_IN := -c
endif
CC_OUT := -o

CFLAGS += -I. -I$(HB_HOST_INC)

ifneq ($(HB_BUILD_WARN),no)
   CFLAGS += -W -Wall
else
   CFLAGS += -W
endif

ifneq ($(HB_BUILD_OPTIM),no)
   CFLAGS += -O3
endif

ifeq ($(HB_BUILD_DEBUG),yes)
   CFLAGS += -g
endif

LD := $(CC)
LD_OUT := -o

LIBPATHS := $(foreach dir,$(LIB_DIR) $(SYSLIBPATHS),-L$(dir))
LDLIBS := $(foreach lib,$(HB_USER_LIBS) $(LIBS) $(SYSLIBS),-l$(lib))

LDFLAGS += $(LIBPATHS)

AR := $(HB_CCPREFIX)ar
AR_RULE = ( $(AR) $(ARFLAGS) $(HB_AFLAGS) $(HB_USER_AFLAGS) rcs $(LIB_DIR)/$@ $(^F) $(ARSTRIP) ) || ( $(RM) $(LIB_DIR)/$@ && $(FALSE) )

include $(TOP)$(ROOT)config/rules.mk
