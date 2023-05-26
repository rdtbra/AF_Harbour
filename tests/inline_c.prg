/*
 * $Id: inline_c.prg 15522 2010-09-22 22:07:21Z vszakats $
 */

PROCEDURE Main()

   QOut( C_FUNC() )

   QOut( EndDumpTest() )

   RETURN

#pragma BEGINDUMP

#include "hbapi.h"

HB_FUNC( C_FUNC )
{
   hb_retc( "returned from C_FUNC()\n" );
}

#pragma ENDDUMP

FUNCTION EndDumpTest()
   RETURN "End Dump Test"
