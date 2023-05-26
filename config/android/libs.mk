#
# $Id: libs.mk 16627 2011-04-19 22:23:34Z druzus $
#

include $(TOP)$(ROOT)config/linux/libs.mk

SYSLIBS := $(filter-out rt pthread, $(SYSLIBS))
