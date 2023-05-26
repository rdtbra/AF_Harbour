#
# $Id: none.mk 16353 2011-02-22 15:01:39Z vszakats $
#

include $(TOP)$(ROOT)config/global.mk

ifneq ($(HB_PLATFORM),)
ifneq ($(HB_COMPILER),)

ifneq ($(LIBNAME),)
   DIR_RULE := @$(ECHO) $(ECHOQUOTE)! '$(LIBNAME)' library skipped $(if $(HB_SKIP_REASON),($(HB_SKIP_REASON)),)$(ECHOQUOTE)
else
ifneq ($(DYNNAME),)
   DIR_RULE := @$(ECHO) $(ECHOQUOTE)! '$(DYNNAME)' dynamic library skipped$(ECHOQUOTE)
else
   DIR_RULE :=
endif
endif

all : first

first clean install::
	$(DIR_RULE)

endif
endif
