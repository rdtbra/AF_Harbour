/*
 * $Id: send.prg 14643 2010-05-31 08:26:06Z druzus $
 */

/*
 * Copyright 2009-2010 Viktor Szakats (harbour.01 syenar.hu)
 * www - http://www.harbour-project.org
 */

#include "common.ch"

PROCEDURE Main( cPort )

#if   defined( __PLATFORM__WINDOWS )
   DEFAULT cPort TO "\\.\COM22"
#elif defined( __PLATFORM__DARWIN )
   DEFAULT cPort TO "/dev/cu.myport-COM1-1"
#endif

   ? "start"
   ? sms_Send( cPort, "555555555", "test msg", .T. )
   ? "end"

   RETURN
