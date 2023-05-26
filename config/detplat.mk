#
# $Id: detplat.mk 16191 2011-02-03 08:20:28Z vszakats $
#

# ---------------------------------------------------------------
# Copyright 2009 Viktor Szakats (harbour.01 syenar.hu)
# See COPYING for licensing terms.
# ---------------------------------------------------------------

ifneq ($(findstring MINGW,$(_DETPLAT_STR)),)
   HB_HOST_PLAT := win
else
ifneq ($(findstring MSys,$(_DETPLAT_STR)),)
   HB_HOST_PLAT := win
else
ifneq ($(findstring Windows,$(_DETPLAT_STR)),)
   HB_HOST_PLAT := win
else
ifneq ($(findstring CYGWIN,$(_DETPLAT_STR)),)
   HB_HOST_PLAT := win
else
ifneq ($(findstring Darwin,$(_DETPLAT_STR)),)
   HB_HOST_PLAT := darwin
else
ifneq ($(findstring darwin,$(_DETPLAT_STR)),)
   HB_HOST_PLAT := darwin
else
ifneq ($(findstring Linux,$(_DETPLAT_STR)),)
   HB_HOST_PLAT := linux
else
ifneq ($(findstring linux,$(_DETPLAT_STR)),)
   HB_HOST_PLAT := linux
else
ifneq ($(findstring HP-UX,$(_DETPLAT_STR)),)
   HB_HOST_PLAT := hpux
else
ifneq ($(findstring hp-ux,$(_DETPLAT_STR)),)
   HB_HOST_PLAT := hpux
else
ifneq ($(findstring SunOS,$(_DETPLAT_STR)),)
   HB_HOST_PLAT := sunos
else
ifneq ($(findstring sunos,$(_DETPLAT_STR)),)
   HB_HOST_PLAT := sunos
else
ifneq ($(findstring BSD,$(_DETPLAT_STR)),)
   HB_HOST_PLAT := bsd
else
ifneq ($(findstring bsd,$(_DETPLAT_STR)),)
   HB_HOST_PLAT := bsd
else
ifneq ($(findstring DragonFly,$(_DETPLAT_STR)),)
   HB_HOST_PLAT := bsd
else
ifneq ($(findstring OS/2,$(_DETPLAT_STR)),)
   HB_HOST_PLAT := os2
else
ifneq ($(findstring MS-DOS,$(_DETPLAT_STR)),)
   HB_HOST_PLAT := dos
else
ifneq ($(findstring msdos,$(_DETPLAT_STR)),)
   HB_HOST_PLAT := dos
else
ifneq ($(findstring beos,$(_DETPLAT_STR)),)
   HB_HOST_PLAT := beos
else
ifneq ($(findstring Haiku,$(_DETPLAT_STR)),)
   HB_HOST_PLAT := beos
endif
ifneq ($(findstring QNX,$(_DETPLAT_STR)),)
   HB_HOST_PLAT := qnx
else
ifneq ($(findstring Minix,$(_DETPLAT_STR)),)
   HB_HOST_PLAT := minix
endif
endif
endif
endif
endif
endif
endif
endif
endif
endif
endif
endif
endif
endif
endif
endif
endif
endif
endif
endif
endif
