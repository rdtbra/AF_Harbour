/*
 * $Id: testevnt.prg 14688 2010-06-04 13:32:23Z vszakats $
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2010 Viktor Szakats (harbour.01 syenar.hu)
 * www - http://harbour-project.org
 *
 */

#include "hbwin.ch"

PROCEDURE Main()

   ? WIN_REPORTEVENT( NIL, "Application", WIN_EVENTLOG_SUCCESS, 0, 0, "hello" )
   ? WIN_REPORTEVENT( NIL, "Application", WIN_EVENTLOG_SUCCESS, 0, 0, { "hello", "world" } )

   RETURN
