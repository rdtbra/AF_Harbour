#
# $Id: global.mk 14251 2010-03-28 09:18:27Z vszakats $
#

all : first

RES_EXT := .res
BIN_EXT := .exe
DYN_EXT := .dll

HB_CFLAGS += -DUNICODE
HB_CFLAGS += -DUNDER_CE

HB_GT_LIBS += gtwvt gtgui

SYSLIBS += coredll ws2
