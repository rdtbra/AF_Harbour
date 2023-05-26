#
# $Id: install.mk 12402 2009-09-05 00:23:51Z vszakats $
#

include $(TOP)$(ROOT)config/instsh.mk

ifneq ($(INSTALL_RULE),)
install:: first
	$(INSTALL_RULE)
endif
