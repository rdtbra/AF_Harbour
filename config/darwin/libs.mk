#
# $Id: libs.mk 14416 2010-05-02 10:30:19Z vszakats $
#

SYSLIBPATHS :=

ifneq ($(HB_LINKING_RTL),)
   ifeq ($(HB_LIBNAME_CURSES),)
      HB_LIBNAME_CURSES := ncurses
   endif
   ifneq ($(HB_HAS_CURSES),)
      SYSLIBS += $(HB_LIBNAME_CURSES)
   endif
   ifneq ($(HB_HAS_SLANG),)
      SYSLIBS += slang
      # In BSD, slang still needs curses :(
      ifneq ($(HB_HAS_CURSES),)
         SYSLIBS += $(HB_LIBNAME_CURSES)
      endif
      ifneq ($(wildcard /sw/lib),)
         SYSLIBPATHS += /sw/lib
      endif
      ifneq ($(wildcard /opt/local/lib),)
         SYSLIBPATHS += /opt/local/lib
      endif
   endif
   ifneq ($(HB_HAS_X11),)
      SYSLIBS += X11
      SYSLIBPATHS += /usr/X11R6/lib
   endif
   ifneq ($(HB_HAS_PCRE),)
      ifeq ($(HB_HAS_PCRE_LOCAL),)
         SYSLIBS += pcre
      endif
   endif
   ifeq ($(HB_HAS_ZLIB_LOCAL),)
      SYSLIBS += z
   endif
endif

SYSLIBS += m
